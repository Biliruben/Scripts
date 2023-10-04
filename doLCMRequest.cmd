@call %scriptsDir%\doEcho.cmd
setlocal
if [] EQU [%1] goto cmdLineArgs
set JSON=%1
set URL=http://localhost:8080/iiq/ui/rest/requestAccess

:doRequest
if not exist %JSON% goto noJson
call http --json --auth james.smith:xyzzy --auth-type basic POST "%URL%" < %JSON%
call getUser.cmd
exit /b

echo I shouldn't be here

:cmdLineArgs
echo JSON provisioning file must be provided
exit /b 1

:noJson
echo %JSON%: file not found
exit /b 2
