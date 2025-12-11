@call %scriptsdir%\doEcho.cmd
setlocal
set JIRA_PREFIX=SET
if not DEFINED GIT_REMOTE call :promptGit

set noPause=true
call %scriptsdir%\setupJira.cmd %*
endlocal
goto eof

:promptGit
set /p setTag=Tag for SET? 
set PULL_BRANCH=%setTag%
set GIT_REMOTE=tags/%setTag%
goto eof

:eof
