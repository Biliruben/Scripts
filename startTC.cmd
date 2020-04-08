@if defined doEcho (
    @echo %doEcho%
) else (
    @echo off
)
rem this is just a normal tomcat startup without jacking around with the env vars. see
rem 'startAltTC' for that shit
setlocal EnableDelayedExpansion
if not defined CATALINA_HOME set CATALINA_HOME=c:\tomcat-7.0.69
pushd %CATALINA_HOME%\bin
set TITLE=Tomcat %httpPort%
if defined doEcho (
    if doEcho==on echo %JAVA_OPTS%
)
call catalina.bat start
popd
endlocal
