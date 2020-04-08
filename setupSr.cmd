@if defined doEcho (
    @echo %doEcho%
) else (
    @echo off
)
setlocal
set JIRA_PREFIX=IIQSR
call %scriptsdir%\setupJira.cmd %*
endlocal
