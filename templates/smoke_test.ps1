# Smoke test: starts the REAL app, checks it over HTTP, then stops it.
# Windows. Run it by double-clicking smoke_test.bat, or from a terminal.
# Nitpick fills in the SETTINGS section for each project.

# ---------------- SETTINGS (edit these) ----------------
# Exactly how a user starts the app. Examples:
#   "npm start"                            a Node app
#   "npx --yes http-server -p 3000 -c-1"   a plain HTML site (needs Node)
#   "npm run build && npm start"           an app with a build step
$StartCommand = "npm start"
$BaseUrl      = "http://localhost:3000"  # where the app answers once running
$StartupWait  = 30                       # seconds to wait; raise it for slow builds
# Each check: a path to request, and text that must appear in the reply.
$Checks = @(
    @{ Path = "/";       Expect = "Welcome" }
    # @{ Path = "/api/health"; Expect = '"ok":true' }
)
# --------------------------------------------------------

$ErrorActionPreference = "Stop"
$ProjectDir = $PSScriptRoot   # this script lives in the project's top folder
$failed = 0
$server = $null

# Returns $null if nothing answered, otherwise the status code and the text.
# Any HTTP reply counts as an answer, including 404 or 500.
function Get-Page($url) {
    try {
        $r = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 10
        $status = [int]$r.StatusCode
        $content = $r.Content
    } catch {
        # An error page (404, 500...) still counts as an answer.
        $resp = $_.Exception.Response
        if ($null -eq $resp) { return $null }
        $status = [int]$resp.StatusCode
        if ($_.ErrorDetails -and $_.ErrorDetails.Message) {
            $content = $_.ErrorDetails.Message            # PowerShell 7
        } else {
            try {                                         # Windows PowerShell 5.1
                $content = (New-Object System.IO.StreamReader($resp.GetResponseStream())).ReadToEnd()
            } catch { $content = "" }
        }
    }
    # Windows PowerShell hands back raw bytes when a reply has no content type.
    if ($content -is [byte[]]) { $content = [System.Text.Encoding]::UTF8.GetString($content) }
    return @{ Status = $status; Text = [string]$content }
}

if (Get-Page $BaseUrl) {
    Write-Host "FAIL: something is already running at $BaseUrl, probably an old copy of the app."
    Write-Host "Close it first, otherwise this test would check the old copy instead of your new code."
    exit 1
}

try {
    Write-Host "Starting app: $StartCommand (in $ProjectDir)"
    $server = Start-Process -FilePath "cmd.exe" -ArgumentList "/c $StartCommand" `
        -WorkingDirectory $ProjectDir -PassThru -WindowStyle Hidden

    $up = $false
    for ($i = 0; $i -lt $StartupWait; $i++) {
        Start-Sleep -Seconds 1
        if ($server.HasExited) { break }
        if (Get-Page $BaseUrl) { $up = $true; break }
    }
    if (-not $up) {
        if ($server.HasExited) {
            Write-Host "FAIL: the app stopped on its own before answering. It probably crashed. Run '$StartCommand' yourself to see the error."
        } else {
            Write-Host "FAIL: app did not answer at $BaseUrl within $StartupWait seconds."
        }
        exit 1
    }
    Write-Host "App is up at $BaseUrl"

    foreach ($c in $Checks) {
        $url = $BaseUrl + $c.Path
        $page = Get-Page $url
        if ($null -eq $page) {
            Write-Host "FAIL: $url did not answer"; $failed++
        } elseif ($page.Status -ge 400) {
            Write-Host "FAIL: $url answered with error $($page.Status)"; $failed++
        } elseif (-not $page.Text.Contains($c.Expect)) {
            Write-Host "FAIL: $url answered but did not contain: $($c.Expect)"; $failed++
        } else {
            Write-Host "ok:   $url contains: $($c.Expect)"
        }
    }
}
finally {
    if ($server -and -not $server.HasExited) {
        # /T stops the whole tree (cmd.exe plus the app it launched).
        taskkill /PID $server.Id /T /F | Out-Null
        # Wait until it has really stopped, so the next run starts clean.
        for ($i = 0; $i -lt 10 -and (Get-Page $BaseUrl); $i++) { Start-Sleep -Seconds 1 }
        Write-Host "App stopped."
    }
}

if ($failed -gt 0) { Write-Host "SMOKE TEST FAIL ($failed check(s) failed)"; exit 1 }
Write-Host "SMOKE TEST PASS"
exit 0
