@echo off
rem for a list of files, given by a file name containing that list, iterate
rem through each entry and print out the most recent change for that file.
rem
setlocal

set FILENAME=%1
call %scriptsdir%\SetScriptID.cmd
set REPORT_FILE=lastChanges_%scrId%.txt
set ERROR_MSG=
set SEP=---------------------------------------------
if not defined FILENAME set ERROR_MSG=You need to give me a file name with a list of files, asshole.
if defined ERROR_MSG goto error
if not exist %FILENAME% set ERROR_MSG=%FILENAME% does not exist, dummy.
if defined ERROR_MSG goto error

for /f %%i in (%FILENAME%) do call :findLastChange %%i
echo Report: %REPORT_FILE%
goto eof

:findLastChange
set ERROR_MSG=
set findFile=%1
echo %findFile%>>%REPORT_FILE%
git log -n1 %findFile%>>%REPORT_FILE% 2>&1
echo %SEP%>>%REPORT_FILE%
if ERRORLEVEL 1 set ERROR_MSG=Error executing 'git log -n1 %findFile%'
if defined ERROR_MSG goto error
goto eof

:error
echo %ERROR_MSG%
endlocal
exit /b 1

:eof
endlocal
