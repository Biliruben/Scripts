@call %SCRIPT_HOME%\doEcho.cmd

if [%1] EQU [] goto noArg
:setlocal
set GIT_HOME=c:\GIT_ESCROW
set version=%1

set EXIT_CODE=0

if exist "%GIT_HOME%" (
    dir %GIT_HOME%
    echo.
    echo Resetting %GIT_HOME%, which means deleting the shit out of everything.
    choice /m "Continue?" /D n /T 30
    if ERRORLEVEL 2 goto discontinue
    rd /s /q %GIT_HOME%
)
mkdir %GIT_HOME%
if ERRORLEVEL 1 GOTO EXIT

rem fullExit is truthy for any value. Uncommenting will allow these scripts to exit on their own
set fullExit=true

for /f "eol=#" %%i in (repoThreads.txt) do start %~p0\checkoutThread.cmd %%i

echo Wait for that stuff to finish before continuing
pause

call %~p0\zipEscrow.cmd
goto exit

:noArg
echo Major version must be passed in. Ex: %0 8.4
set EXIT_CODE=4
goto exit

:discontinue
set EXIT_CODE=3
goto exit

:exit
exit /b %EXIT_CODE%
