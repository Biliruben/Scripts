@call %script_home%\doEcho.cmd
setlocal EnableDelayedExpansion
if defined INIT_IMPORT_FILE goto initAlreadyKnown
:promptInit
echo.
dir /b %SCRIPT_HOME%\initIIQ-import*iiq
set /p initChoice=INIT_IMPORT_FILE? $ 
if defined initChoice set INIT_IMPORT_FILE=%SCRIPT_HOME%\%initChoice%
if not defined initChoice set INIT_IMPORT_FILE=
:continueExec
if defined INIT_EXEC_FILE goto execAlreadyKnown
:promptExec
echo.
echo doNothing.iiq
dir /b %SCRIPT_HOME%\initIIQ-execute*iiq
set /p execChoice=INIT_EXEC_FILE? $ 
if defined execChoice set INIT_EXEC_FILE=%SCRIPT_HOME%\%execChoice%
if not defined execChoice set INIT_EXEC_FILE=
goto endLocal

:initAlreadyKnown
echo.
echo INIT_IMPORT_FILE=%INIT_IMPORT_FILE%
choice /C ny /m Overwrite? /D n /t 30
if ERRORLEVEL 2 goto promptInit
goto continueExec

:execAlreadyKnown
echo.
echo INIT_EXEC_FILE=%INIT_EXEC_FILE%
choice /C ny /m Overwrite? /D n /t 30
if ERRORLEVEL 2 goto promptExec
goto eof

:endLocal
endlocal & set INIT_IMPORT_FILE=%INIT_IMPORT_FILE%& set INIT_EXEC_FILE=%INIT_EXEC_FILE%
goto eof

:eof
echo.
echo INIT_IMPORT_FILE=%INIT_IMPORT_FILE%
echo INIT_EXEC_FILE=%INIT_EXEC_FILE%
