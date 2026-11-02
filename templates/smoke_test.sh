#!/bin/sh
# Smoke test: starts the REAL app, checks it over HTTP, then stops it.
# Mac/Linux. Run with:  sh smoke_test.sh
# (On Windows, use smoke_test.bat instead.)
# Nitpick fills in the SETTINGS section for each project.

# ---------------- SETTINGS (edit these) ----------------
# Exactly how a user starts the app. Examples:
#   "npm start"                            a Node app
#   "npx --yes http-server -p 3000 -c-1"   a plain HTML site (needs Node)
#   "npm run build && npm start"           an app with a build step
START_COMMAND="npm start"
BASE_URL="http://localhost:3000"       # where the app answers once running
STARTUP_WAIT=30                        # seconds to wait; raise it for slow builds
# Each check: path|text that must appear in the reply. One per line.
# Quotes are fine here; type the text exactly as it appears.
checks() {
cat <<'END_OF_CHECKS'
/|Welcome
END_OF_CHECKS
}
# --------------------------------------------------------

cd "$(dirname "$0")" || exit 1

# Prints the HTTP status code, or 000 if nothing answered.
# Any HTTP reply counts as an answer, including 404 or 500.
status_of() { curl -s -o /dev/null -w '%{http_code}' --max-time 10 "$1"; }

if [ "$(status_of "$BASE_URL")" != "000" ]; then
  echo "FAIL: something is already running at $BASE_URL, probably an old copy of the app."
  echo "Close it first, otherwise this test would check the old copy instead of your new code."
  exit 1
fi

# Start the app in its own process group, so stopping it also stops
# anything it launched (npm starts node as a separate process).
set -m
sh -c "$START_COMMAND" > smoke_test.log 2>&1 &
SERVER_PID=$!
set +m
echo "Starting app: $START_COMMAND"
stop_app() {
  kill -TERM "-$SERVER_PID" 2>/dev/null || kill -TERM "$SERVER_PID" 2>/dev/null
  wait "$SERVER_PID" 2>/dev/null
  i=0
  while [ $i -lt 10 ] && [ "$(status_of "$BASE_URL")" != "000" ]; do sleep 1; i=$((i + 1)); done
  echo "App stopped."
}
trap stop_app EXIT

up=0; i=0
while [ $i -lt "$STARTUP_WAIT" ]; do
  sleep 1; i=$((i + 1))
  if ! kill -0 "$SERVER_PID" 2>/dev/null; then
    echo "FAIL: the app stopped on its own before answering. It probably crashed. See smoke_test.log."
    exit 1
  fi
  if [ "$(status_of "$BASE_URL")" != "000" ]; then up=1; break; fi
done
if [ $up -ne 1 ]; then
  echo "FAIL: app did not answer at $BASE_URL within $STARTUP_WAIT seconds (see smoke_test.log)"
  exit 1
fi
echo "App is up at $BASE_URL"

results=$(checks | while IFS='|' read -r path expect; do
  [ -z "$path" ] && continue
  code=$(status_of "$BASE_URL$path")
  if [ "$code" = "000" ]; then
    echo "FAIL: $BASE_URL$path did not answer"
  elif [ "$code" -ge 400 ]; then
    echo "FAIL: $BASE_URL$path answered with error $code"
  elif curl -s --max-time 10 "$BASE_URL$path" | grep -qF -- "$expect"; then
    echo "ok:   $BASE_URL$path contains: $expect"
  else
    echo "FAIL: $BASE_URL$path answered but did not contain: $expect"
  fi
done)
echo "$results"
failed=$(printf '%s\n' "$results" | grep -c '^FAIL')

if [ "$failed" -gt 0 ]; then
  echo "SMOKE TEST FAIL ($failed check(s) failed)"; exit 1
fi
echo "SMOKE TEST PASS"
