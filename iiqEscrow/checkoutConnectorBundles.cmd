rem @echo off
setlocal

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

for /f %%i in (%~p0\connBundles.txt) do call "%~p0\baseCheckout.cmd" %%i %%i_GA_%version%

:exit
if defined fullExit exit %EXIT_CODE%
exit /b %EXIT_CODE%

:eof
