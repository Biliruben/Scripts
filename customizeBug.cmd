@if defined doEcho (@echo %doEcho%) else (@echo off)
set /p GIT_REMOTE=GIT_REMOTE [remotes/origin/7.2p-develop]? 
if ERRORLEVEL 1 set GIT_REMOTE=
set /p PULL_BRANCH=PULL_BRANCH [7.2p-develop]? 
if ERRORLEVEL 1 set PULL_BRANCH=
set /p IIQ_TAG=IIQ_TAG[iiq72p_e3322]? 
if ERRORLEVEL 1 set IIQ_TAG=
set /p local_branch=local_branch [tkirk/iiqetn3322-7.2p]? 
if ERRORLEVEL 1 set local_branch=
call %scriptsdir%\gitBuildStatus.cmd
:eof
