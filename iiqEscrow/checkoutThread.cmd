call %script_home%\doEcho.cmd
setlocal
if [%1] EQU [] goto noArg
set thread=%1

set EXIT_CODE=0
if not defined version (
    echo version not defined!
    set EXIT_CODE=1
)

if not defined GIT_HOME (
    echo GIT_HOME not defined!
    set EXIT_CODE=2
)

if not exist "%GIT_HOME%" (
    echo %GIT_HOME% does not exist
    set EXIT_CODE=3
)

if %EXIT_CODE% GTR 0 goto exit

for /f "delims=; tokens=2,3,4,5" %%i in ('findstr /b /c:"%thread%;" repoVersions.txt') do call :doBaseCheckout %%i %%j %%j_GA_%version% %%k "%%l"

if %EXIT_CODE% GTR 0 goto exit
goto full_exit

:noArg
echo Thread token must be passed in
set EXIT_CODE=5
goto exit

:doBaseCheckout
call %~p0\baseCheckout.cmd %1 %2 %3 %4 %5
set /a EXIT_CODE=%EXIT_CODE% + %ERRORLEVEL%
goto eof

:exit
exit /b %EXIT_CODE%

:full_exit
if defined fullExit exit %EXIT_CODE%

:eof
