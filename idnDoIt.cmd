@echo off
rem starts all the stuff that needs starting

setlocal
if [%1] NEQ [] set CLEAN=true

set GIT_REPO_BASE=c:\GITRoot
if not defined GIT_CLOUD_REPO set GIT_CLOUD_REPO=cloud-ssh
set MANTIS_GIT_REPO=%GIT_REPO_BASE%\mantis-ssh
set CC_PROJECT_HOME=%GIT_REPO_BASE%\%GIT_CLOUD_REPO%\cloudcommander
set CIS_PROJECT_HOME=%GIT_REPO_BASE%\%GIT_CLOUD_REPO%\iiq
set VA_HOME=%GIT_REPO_BASE%\%GIT_CLOUD_REPO%\misc\vagrant
set CIS_TOMCAT_HOME=c:\tomcat-7.0.69
set VAGRANT_DO_CMD="sudo su - sailpoint & service va restart & service ccg restart"
call :checkRedis
if %REDIS_OK%==no exit /b 1
call :startCC
call :startVagrant
call :startCIS
call :startMantis
goto eof

:checkRedis
echo Checking Redis...
call islive.cmd 6379
if ERRORLEVEL 1 (
    echo REDIS is not live!
    set REDIS_OK=no
) else (
    set REDIS_OK=yes
)
goto eof

:startMantis
echo Starting Mantis...
call islive.cmd 7100 > nul
if ERRORLEVEL 1 (
    pushd %MANTIS_GIT_REPO%
    call git pull origin
    if defined CLEAN call gradlew clean
    start "Mantis" gradlew build :mantis-dev:run -x assemble -x test
    call :doWhile "islive.cmd 7100 > nul" 0 20
    popd
) else (
    echo Mantis already started!
)
goto eof

:startCIS
echo Starting CIS...
call islive.cmd 8082 > nul
if ERRORLEVEL 1 (
    pushd %CIS_TOMCAT_HOME%\bin
    call catalina jpda start
    call :doWhile "islive.cmd 8082 > nul" 0 20
    popd
) else (
    echo CIS already started!
)
goto eof

:startVagrant
echo Starting VA...
pushd %VA_HOME%
call vagrant status va | findstr /c:running
if ERRORLEVEL 1 (
    call c:\HashiCorp\Vagrant\bin\vagrant up va
) else (
    echo Vagrant already started!
)
call vagrant ssh --command %VAGRANT_DO_CMD% va
popd
goto eof

:startCC
echo Starting CC...
call islive.cmd 8080 > nul
if ERRORLEVEL 1 (
    pushd %CC_PROJECT_HOME%
    if defined CLEAN call grailsw clean
    pushd ..\iiq
    if defined CLEAN call mvn clean
    popd
    call git pull origin
    start "Cloud Commander" grailsw run-app
    call :doWhile "islive.cmd 8080 > nul" 0 20
    popd
) else (
    echo CC already started!
)
goto eof

:DeQuote
rem Fucking Windows...
for /f "delims=" %%A in ('echo %%%1%%') do set %1=%%~A
goto eof

:doWhile
set CMD=%1
set REQ_RESPONSE=%2
set DELAY=%3
set TOTAL_DELAY=%DELAY%
call :DeQuote CMD
if not defined DELAY set DELAY=5
:do
call %CMD%
rem If errorlevel is the required response, move on
if %ERRORLEVEL% EQU %REQ_RESPONSE% goto eof
echo Waiting %TOTAL_DELAY% seconds...
set /a TOTAL_DELAY=%TOTAL_DELAY% + %DELAY%
sleep %DELAY%
goto do


:eof
