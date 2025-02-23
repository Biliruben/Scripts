rem @echo off

:setlocal
set GIT_HOME=c:\GIT_ESCROW
set version=8.4

set EXIT_CODE=0

if not exist "%GIT_HOME%" (
    echo %GIT_HOME% does not exist
    set EXIT_CODE=3
)

for /d %%i in (%GIT_HOME%\*) do rd /s /q %%i

if %EXIT_CODE% GTR 0 goto exit


set fullExit=true
start %~p0\checkoutIIQSrc.cmd
start %~p0\checkoutConnectorBundles.cmd
start %~p0\checkoutGatewaySrc.cmd
start %~p0\checkoutMisc.cmd

echo Wait for that stuff to finish before continuing
pause

pushd %GIT_HOME%
jar -cvfM identityiq-%version%.zip .
popd

:exit
exit /b %EXIT_CODE%
