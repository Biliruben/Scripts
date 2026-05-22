@call %scriptsDir%\doEcho.cmd
setlocal
if defined DOLCM_AUTH (
    echo Setting AUTH: %DOLCM_AUTH%
    set AUTH=%DOLCM_AUTH%
) else (
    set AUTH=james.smith:xyzzy
)
if [%1] EQU [] goto noId
set APP_ID=%1
call %~p0\iiqRest\getUiUrl.cmd

if not defined URL set URL=%UI_URL%/approvals/%APP_ID%

echo %URL%
call http --json --auth %AUTH% --auth-type basic POST "%URL%/approveAll" approvalId=%APP_ID%
call http --json --auth %AUTH% --auth-type basic POST "%URL%/complete"
exit /b

echo I shouldn't be here

:noId
echo No Approval ID provided
exit /b 1

