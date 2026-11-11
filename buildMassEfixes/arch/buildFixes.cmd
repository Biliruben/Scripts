@call doEcho
if not defined EFIX_REPO goto noEfixRepoDefined
if not exist "%EFIX_REPO%" goto noEfixRepo
setlocal
set securityData=securityFixData.txt
if not exist %securityData% goto noData
set script=%~p0\buildFix.cmd
rem Main wrapper
rem Iteration cmd:
for /f "tokens=1,2,3,4 delims=, eol=#" %%i in (securityFixData.txt) do call "%script%" %%i %%j %%k "%%l"
endlocal

rem build the checksums. Ignore any file determination and just assume all Zips in the efix directory
rem need checksums
pushd "%EFIX_REPO%\efix"
call %scriptsdir%\getCheckSum *.zip
popd
goto eof

:noEfixRepoDefined
echo EFIX_REPO env variable not defined!
exit /b 1
:noEfixRepo
echo %EFIX_REPO% not found!
exit /b 2
:noData
%securityData% file not found.
exit /b 3

:eof
