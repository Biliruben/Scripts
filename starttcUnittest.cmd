@if defined doEcho (
    @echo %doEcho%
) else (
    @echo off
)
setlocal
set CATALINA_OPTS=-DspringConfig=unittest -DiiqBeans=unittest -Dsailpoint.spring=unittest
call %SCRIPT_HOME%\doTC.cmd start %*
