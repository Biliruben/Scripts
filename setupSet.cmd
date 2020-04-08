@set doEcho=off
@echo %doEcho%
setlocal
set JIRA_PREFIX=SET
set /p setTag=Tag for SET? 
set PULL_BRANCH=%setTag%
set GIT_REMOTE=tags/%setTag%
set noPause=true
call %scriptsdir%\setupJira.cmd %*
endlocal
