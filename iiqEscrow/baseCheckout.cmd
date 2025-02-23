rem @echo off
setlocal
set gitRepo=%~1
set targetDir=%~2

set EXIT_CODE=0

if not defined GIT_HOME (
    echo GIT_HOME not defined!
    set EXIT_CODE=2
)

if not exist "%GIT_HOME%" (
    echo %GIT_HOME% does not exist
    set EXIT_CODE=3
)

if %EXIT_CODE% GTR 0 goto exit

pushd "%GIT_HOME%"
call git clone git@github.com:sailpoint/%gitRepo%.git %targetDir%
if ERRORLEVEL 1 (
    echo Checkout failed
    set EXIT_CODE=4
)
if %EXIT_CODE% GTR 0 goto exit

pushd %targetDir%
rd /s /q .git
popd
popd
goto eof

:exit
exit /b %EXIT_CODE%

:eof
