@call %scriptsdir%\doEcho.cmd
@echo %doEcho%
setlocal
set JIRA_PREFIX=EFIX
set LOCAL_BRANCH_PREFIX=efix/tkirk
set /p efixTag=Tag to efix? 
set PULL_BRANCH=%efixTag%
set GIT_REMOTE=tags/%efixTag%
set noPause=true
call %scriptsdir%\setupJira.cmd %*
endlocal
