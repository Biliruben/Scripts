@if defined doEcho (
    @echo %doEcho%
) else (
    @echo off
)
rem this is just a normal tomcat shutdown without jacking around with the env vars.
call %SCRIPT_HOME%\doTC.cmd start
