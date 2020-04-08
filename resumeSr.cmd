@set doEcho=off
@echo %doEcho%
setlocal
set JIRA_PREFIX=IIQSR
call %scriptsdir%\resumeJira.cmd %*
endlocal
