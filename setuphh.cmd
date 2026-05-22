@if not defined doEcho set doEcho=off
@echo %doEcho%
setlocal
set JIRA_PREFIX=IIQHH
call %scriptsdir%\setupJira.cmd %*
endlocal
