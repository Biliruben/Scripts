rem @echo off
setlocal
set gitOrg=%~1
set gitRepo=%~2
set targetDir=%~3
set checkoutTag=%~4
set cloneArg=
if [%5] NEQ [] set cloneArg=%~5

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
call git clone %cloneArg% git@github.com:%gitOrg%/%gitRepo%.git %targetDir%
if ERRORLEVEL 1 (
    echo Clone failed
    set EXIT_CODE=4
)
if %EXIT_CODE% GTR 0 goto exit

pushd %targetDir%

call git checkout -f %checkoutTag%

if ERRORLEVEL 1 (
    echo Checkout failed
    set EXIT_CODE=4
)

if %EXIT_CODE% GTR 0 goto exit

rd /s /q .git
popd
popd
goto eof

:exit
exit /b %EXIT_CODE%

:eof
