@if defined doEcho (
    @echo %doEcho%
) else (
    @echo off
)
if not defined IIQ_CMD choice /t 7 /D N /M "Persist variables"
set persistVars=%ERRORLEVEL%
call %scriptsdir%\SetScriptID.cmd
set persistFileName=%TEMP%\persist_%ScrID%.cmd
if %persistVars% EQU 1 echo Variables persisted in %persistFileName%
set demoDataBasePath=c:\GITRoot\iiq-test\demodata\previousVersions
setlocal
if not defined SCRIPT_HOME set SCRIPT_HOME=%~d0%~p0
rem check env vars; I've set this to N to disable this for the time being
if not defined START_TOMCAT (
    choice /d n /t 30 /m "Start tomcat after setup?"
    if %ERRORLEVEL% EQU 0 (
        set START_TOMCAT=Y
    ) else (
        set START_TOMCAT=N
    )
)
if not defined CATALINA_HOME (
    set /p CATALINA_HOME=CATALINA_HOME [c:\tomcat-7.0.69] $ 
    if ERRORLEVEL 1 set CATALINA_HOME=c:\tomcat-7.0.69
)

if not defined REPO_HOME set /p REPO_HOME=REPO_HOME [%CD%] $ 
if ERRORLEVEL 1 set REPO_HOME=%CD%
if not defined IIQ_TAG set /p IIQ_TAG=IIQ_TAG $ 
if ERRORLEVEL 1 (
    echo IIQ_TAG must be specified
    goto eof
)

if not defined ANT_TASK set ANT_TASK=clean,dist
if ERRORLEVEL 1 set ERROR_MSG=Checkout failed!
if defined ERROR_MSG goto error

rem IIQ_DEMO_DATA is the full path, usually set by some other scripts
rem if it's set, ignore all of this noise
if not defined IIQ_DEMO_DATA (
    if not defined DEMO_DATA (
        dir /b %demoDataBasePath%\DemoData-*.zip
        set /p DEMO_DATA=DEMO_DATA file name $ 
    )
)
if not defined IIQ_CMD (
    set /p IIQ_CMD=IIQ_CMD $ 
)

if %persistVars% EQU 1 (
    echo set REPO_HOME=%REPO_HOME%> %persistFileName%
    echo set IIQ_TAG=%IIQ_TAG%>> %persistFileName%
    echo set DEMO_DATA=%DEMO_DATA%>> %persistFileName%
    echo set CATALINA_HOME=%CATALINA_HOME%>> %persistFileName%
    echo set SCRIPT_HOME=%SCRIPT_HOME%>> %persistFileName%
    echo set START_TOMCAT=%START_TOMCAT%>> %persistFileName%
    if defined IIQ_CMD echo set IIQ_CMD=%IIQ_CMD%>> %persistFileName%
)
rem Convert DEMO_DATA to IIQ_DEMO_DATA to merge two competing conventions
if not defined IIQ_DEMO_DATA set IIQ_DEMO_DATA=%demoDataBasePath%\%DEMO_DATA%

call %SCRIPT_HOME%\quickSetupStatus.cmd

pushd %REPO_HOME%
call %SCRIPT_HOME%\workstationutil.cmd convertIIQProperties %REPO_HOME%\src %IIQ_TAG%
call %SCRIPT_HOME%\increaseBuildMem 2048m
call ant %ANT_TASK%
if ERRORLEVEL 1 goto error
pushd %REPO_HOME%\build
if defined IIQ_DEMO_DATA jar -xvf %IIQ_DEMO_DATA%
if ERRORLEVEL 1 goto error
pushd %REPO_HOME%\build\web-inf\bin
call %SCRIPT_HOME%\initiiq.cmd %IIQ_TAG%
if defined IIQ_CMD call iiq.bat console -c "%IIQ_CMD%"

popd
popd
popd

if defined CATALINA_HOME (
    echo CATALINA_HOME set to "%CATALINA_HOME%"
    if %START_TOMCAT%==Y (
        echo START_TOMCAT set to %START_TOMCAT%
        pushd %CATALINA_HOME%\bin
        call startup
        popd
    )
)

if %persistVars% EQU 1 (
    endlocal

    echo Persisting values...
    call %persistFileName%
    del /q %persistFileName%
) else (
    endlocal
)

goto eof

:error
echo FAILED!!

:eof
