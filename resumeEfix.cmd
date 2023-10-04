@set doEcho=off
@echo %doEcho%
setlocal
set JIRA_PREFIX=EFIX
echo JIRA_PREFIX=%JIRA_PREFIX%
set LOCAL_BRANCH_PREFIX=efix/tkirk
call %scriptsdir%\resumeJira.cmd %*
endlocal
