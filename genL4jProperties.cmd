@call %SCRIPT_HOME%\doEcho.cmd
setlocal

if [%1] EQU [] goto noFile
set CLASS_FILE=%1
if not exist %CLASS_FILE% goto noClassFile

for /f %%i in (%CLASS_FILE%) do call :doClass %%i
goto eof

:doClass
set clazz=%1
set clazz_spaced=%clazz:.= %
set last=
for %%i in (%clazz_spaced%) do set last=%%i
set logger=%last%_%RANDOM%
echo logger.%logger%.name=%clazz%
echo logger.%logger%.level=trace
echo.
goto eof

:noFile
echo No file provided (gimmie a file with classes listed)
goto eof

:noClassFile
echo %CLASS_FILE% not found (gimmie a file with classes listed)
goto eof

:eof
