@call doEcho
rem checks if a port is listening
setlocal
set PORT=%1
set RET_MSG=OK
call netstat -an | findstr /c:%PORT% | findstr /c:LISTENING > nul
set ERR=%ERRORLEVEL%
if %ERR% GEQ 1 set RET_MSG=FAILED
echo %RET_MSG%
exit /B %ERR%
