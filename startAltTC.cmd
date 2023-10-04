@if defined doEcho (
    @echo %doEcho%
) else (
    @echo off
)
setlocal EnableDelayedExpansion
if [%1] EQU [] (
    set INCR=1
) else (
    set INCR=%1
)
if not defined IIQ_HOSTNAME set IIQ_HOSTNAME=ALTTC
set IIQ_HOSTNAME=!IIQ_HOSTNAME:%IIQ_HOSTNAME%=%IIQ_HOSTNAME%_%INCR%!
set /a httpPort=8080 + %INCR%
set /a ajcPort=8009 + %INCR%
set /a httpsPort=8443 + %INCR%
set /a shutdownPort=8005 + 10 + %INCR%
:: Don't do a string replace here since we can't be sure what the value is really
:: set to. Just prepend the whole thing with what we want. It should take
:: precedence
set JAVA_OPTS=-Diiq.hostname=%IIQ_HOSTNAME% %JAVA_OPTS%
set JAVA_OPTS=!JAVA_OPTS:8080=%httpPort%!
set JAVA_OPTS=!JAVA_OPTS:8009=%ajcPort%!
set JAVA_OPTS=!JAVA_OPTS:8443=%httpsPort%!
set JAVA_OPTS=!JAVA_OPTS:8005=%shutdownPort%!
if defined doEcho (
    if doEcho==on echo %JAVA_OPTS%
)
call %SCRIPT_HOME%\doTC.cmd start
endlocal
