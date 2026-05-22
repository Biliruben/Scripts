@call %scriptsDir%\doEcho.cmd
setlocal
if defined UI_URL goto eof
call %~p0\getBaseUrl.cmd
set UI_URL=%BASE_REST_URL%/ui/rest
endlocal & set UI_URL=%UI_URL%
