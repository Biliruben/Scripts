@set doEcho=off
@echo %doEcho%
setlocal
set JIRA_PREFIX=IIQETN
call %scriptsdir%\setupJira.cmd %*
endlocal
