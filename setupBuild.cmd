@if defined doEcho (
    @echo %doEcho%
) else (
    @echo off
)
setlocal
set JIRA_PREFIX=BUILD
set tagPrefix=b
call %scriptsdir%\setupJira.cmd %*
endlocal
