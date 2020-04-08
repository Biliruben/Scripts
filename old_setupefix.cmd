@set doEcho=on
@echo %doEcho%
setlocal
if "%~2"=="" set ERROR_MSG=Two parameters must be passed: The TAG and the EFIX number
if defined ERROR_MSG goto error

rem setup our env vars
rem Override jira_prefix here, within the setlocal block
set JIRA_PREFIX=efix
call %scriptsdir%\setupEfixEnv.cmd %*


rem A little opp for our caller to complain
cd /d %REPO_HOME%
echo Finding previous instances of bug: %IIQ_EFIX%
call %scriptsdir%\findbug.cmd %IIQ_EFIX%
echo Current branch status:
git status
git bugz
echo.
echo IIQ_VERSION=%IIQ_VERSION%
echo IIQ_EFIX=%IIQ_EFIX%
echo GIT_REMOTE=%GIT_REMOTE%
echo PULL_TAG=%PULL_TAG%
echo ANT_HOME=%ANT_HOME%
echo ANT_TASKS=%ANT_TASKS%
echo SCRIPT_HOME=%SCRIPT_HOME%
echo REPO_HOME=%REPO_HOME%
echo IIQ_TAG=%IIQ_TAG%
echo LOCAL_BRANCH=%LOCAL_BRANCH%
echo JAVA_HOME=%JAVA_HOME%
echo.
rem Debug
rem env
choice /C YN /M "Ready?" /T 300 /D N
if ERRORLEVEL 2 (
set ERROR_MSG=You said 'naw'
goto error
)

rem first, a little house cleaning
call c:\scripts\cleanGitRej.cmd

call %scriptsdir%\setupEfixBranch.cmd
if ERRORLEVEL 1 set ERROR_MSG="Branch setup failed"
if defined ERROR_MSG goto error

endlocal
goto end

:noDemoData
echo %IIQ_DEMO_DATA% is not available.  You'll have to manually implement it 1>&2
goto end




:error
echo %ERROR_MSG% 1>&2
endlocal
goto end



:end
