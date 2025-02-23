@call doEcho.cmd
setlocal
set JSON_FILE=%1
set DEST_FILE=c:\temp\content.html
if [%2] NEQ [] set DEST_FILE=%~2
set cmd=jq .content %JSON_FILE%
echo %cmd% ^> "%DEST_FILE%"
call %cmd% > "%DEST_FILE%"
call "%DEST_FILE%"
endlocal
