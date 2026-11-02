@echo off
rem Double-click to run the smoke test. The real work is in smoke_test.ps1.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0smoke_test.ps1"
set RESULT=%ERRORLEVEL%
echo.
if "%1"=="" pause
exit /b %RESULT%
