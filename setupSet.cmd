@set doEcho=off
@echo %doEcho%
rem setlocal
set JIRA_PREFIX=SET
if not DEFINED GIT_REMOTE (
set /p setTag=Tag for SET? 
    set PULL_BRANCH=%setTag%
    set GIT_REMOTE=tags/%setTag%
)
set noPause=true
call %scriptsdir%\setupJira.cmd %*
rem endlocal
