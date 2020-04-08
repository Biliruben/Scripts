@if not defined doEcho set doEcho=off
@echo %doEcho%
setlocal
set JIRA_PREFIX=IIQTC
call %scriptsdir%\setupJira.cmd %*
endlocal
