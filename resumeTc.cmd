@set doEcho=off
@echo %doEcho%
setlocal
set JIRA_PREFIX=IIQTC
call %scriptsdir%\resumeJira.cmd %*
endlocal
