@echo off
setlocal
rem pushd c:\GITRoot\cloud-ssh\cloud-test
set POD_URL=%1
set POD_ORG=%2
set TEST=%3
set RESET_ORG=false
set REPEAT=1
if [%4] NEQ [] set RESET_ORG=%4
if [%5] NEQ [] set REPEAT=%5
echo POD_URL: %POD_URL%
echo POD_ORG: %POD_ORG%
echo TEST: %TEST%
echo RESET_ORG: %RESET_ORG%
echo REPEAT: %REPEAT%
echo PWD: %CD%
choice /T 30 /D N /M Contiue?
if ERRORLEVEL 2 goto exit
for /l %%i in (1,1,%REPEAT%) do call mvn -DpodUrl=%POD_URL% -DtestOrg=%POD_ORG% -DresetOrg=%RESET_ORG% -DshowTestMenu=false -Dtest=%TEST% test

:exit
endlocal
