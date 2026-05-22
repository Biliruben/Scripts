@if defined doEcho (
    @echo %doEcho%
) else (
    @echo off
)
rem this is just a normal tomcat shutdown without jacking around with the env vars.
if [%1] EQU [unittest] (
    shift
    call :startUnittest %*
) else (
    call :starttc %*
)
goto eof

:starttc
call %SCRIPT_HOME%\doTC.cmd start %*
goto eof

:startUnittest
call %SCRIPT_HOME%\starttcUnittest.cmd %*
goto eof

:eof
