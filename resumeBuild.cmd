@set doEcho=off
@echo %doEcho%
setlocal
set JIRA_PREFIX=BUILD
set tagPrefix=b
call %scriptsdir%\resumeJira.cmd %*
endlocal
