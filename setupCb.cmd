@if not defined doEcho set doEcho=off
@echo %doEcho%
setlocal
set JIRA_PREFIX=IIQCB
call %scriptsdir%\setupJira.cmd %*
endlocal
