@call %scriptsDir%\doEcho.cmd
setlocal
if defined DOLCM_AUTH (
    echo Setting AUTH: %DOLCM_AUTH%
    set AUTH=%DOLCM_AUTH%
) else (
    set AUTH=james.smith:xyzzy
)
if [] EQU [%1] goto cmdLineArgs
set JSON=%1
set URL=http://localhost:8080/iiq/ui/rest/requestAccess

:doRequest
if not exist %JSON% goto noJson
call http --json --auth %AUTH% --auth-type basic POST "%URL%" < %JSON%
exit /b

echo I shouldn't be here

:cmdLineArgs
echo JSON provisioning file must be provided on cmdline
exit /b 1

:noJson
echo %JSON%: file not found
exit /b 2
