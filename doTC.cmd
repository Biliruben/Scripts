@if defined doEcho (
    @echo %doEcho%
) else (
    @echo off
)
rem This is the "do-er" script for start/stopTC
setlocal EnableDelayedExpansion
set TC_CMD=%1
if [%TC_CMD%] EQU [] set TC_CMD=start
if not defined CATALINA_HOME set CATALINA_HOME=c:\tomcat-7.0.69
pushd %CATALINA_HOME%\bin
rem defaults
set TITLE=Tomcat %httpPort%
if defined doEcho (
    if doEcho==on echo %JAVA_OPTS%
)
call catalina.bat %TC_CMD%
popd
endlocal
