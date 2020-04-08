@set doEcho=off
@echo %doEcho%
setlocal
set JIRA_PREFIX=SET
echo JIRA_PREFIX=%JIRA_PREFIX%
call %scriptsdir%\resumeJira.cmd %*
endlocal
