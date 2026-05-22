@call %scriptsDir%\doEcho.cmd
setlocal
if defined DOLCM_AUTH (
    echo Setting AUTH: %DOLCM_AUTH%
    set AUTH=%DOLCM_AUTH%
) else (
    set AUTH=james.smith:xyzzy
)
echo AUTH=%AUTH%
if [] EQU [%2] goto cmdLineArgs
set CERT_ID=%1
set JSON=%2
call %~p0\iiqRest\getUiUrl.cmd
if not defined CERT_URL set CERT_URL=%UI_URL%/certifications
if not defined URL set URL=%CERT_URL%/%CERT_ID%/decisions

:doRequest
if not exist %JSON% goto noJson
echo %URL%
call http --json --auth %AUTH% --auth-type basic POST "%URL%" < %JSON%
exit /b

echo I shouldn't be here

:cmdLineArgs
echo CertificationID and JSON  must be provided on cmdline
echo.
echo %0 ac14043e9d621e23819d630aefdc012c certDecision.json
exit /b 1

:noJson
echo %JSON%: file not found
exit /b 2
