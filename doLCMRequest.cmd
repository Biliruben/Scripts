@call %scriptsDir%\doEcho.cmd
setlocal
echo DOLCM_AUTH=%DOLCM_AUTH%
if defined DOLCM_AUTH (
    echo Setting AUTH: %DOLCM_AUTH%
    set AUTH=%DOLCM_AUTH%
) else (
    set AUTH=james.smith:xyzzy
)
if [] EQU [%1] goto cmdLineArgs
set JSON=%1
call %~p0\iiqRest\getUiUrl.cmd
echo AUTH=%AUTH%
if not defined URL set URL=%UI_URL%/requestAccess

:doRequest
if not exist %JSON% goto noJson
echo %URL%
call http --json --auth %AUTH% --auth-type basic POST "%URL%" < %JSON%
exit /b

echo I shouldn't be here

:cmdLineArgs
echo JSON provisioning file must be provided on cmdline
exit /b 1

:noJson
echo %JSON%: file not found
exit /b 2
