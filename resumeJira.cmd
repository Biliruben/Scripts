rem @set doEcho=off
@echo %doEcho%
rem debug on JIRA_PREFIX
if %doEcho%==on echo JIRA_PREFIX=%JIRA_PREFIX%
set ERROR_MSG=
if "%~1"=="" set ERROR_MSG=Two parameters must be passed: The IIQ Version and the Bug Number
if "%~2"=="" set ERROR_MSG=Two parameters must be passed: The IIQ Version and the Bug Number
if defined ERROR_MSG goto error
rem Setup SSH agent
rem Do this before setlocal so the env vars stick
rem Don't need this anymore
rem if not DEFINED SSH_AGENT_PID call %scriptsdir%\setupGitSSH.cmd
setlocal
if "%~3"=="--noStash" (
    set NO_STASH=--noStash
) else (
    set NO_STASH=
    if not "%~3"=="" set MERGE_HASH=%3
)

rem setup our env vars
call %scriptsdir%\setupBugEnv.cmd %*

rem Switch to the appropriate JDK / NodeJS before confirming setup
call %scriptsdir%\switchIIQ.cmd %IIQ_VERSION%
rem A little opp for our caller to complain
if not defined bugSearchTerm set bugSearchTerm %IIQ_BUG%
echo Finding previous instances of bug: %bugSearchTerm%
call %scriptsdir%\findbug.cmd %bugSearchTerm%

echo Current branch status:
git status
if errorlevel 1 (
set ERROR_MSG=You're not in a Gitty repository!
goto error
)
git bugz
call %scriptsdir%\gitBuildStatus.cmd
goto endcomment

:comment
!!! These are no longer called here in this script, left just for
documentation sake.
echo.
echo IIQ_VERSION=%IIQ_VERSION%
echo IIQ_BUG=%IIQ_BUG%
if defined MERGE_HASH echo MERGE_HASH=%MERGE_HASH%
if defined NO_STASH echo NO_STASH=%NO_STASH%
echo ANT_HOME=%ANT_HOME%
echo ANT_TASKS=%ANT_TASKS%
echo SCRIPT_HOME=%SCRIPT_HOME%
echo IIQ_TEST_HOME=%IIQ_TEST_HOME%
echo IIQ_DEMO_DATA=%IIQ_DEMO_DATA%
echo REPO_HOME=%REPO_HOME%
echo IIQ_TAG=%IIQ_TAG%
echo local_branch=%local_branch%
echo JAVA_HOME=%JAVA_HOME%
echo.
:endcomment

if defined NO_BRANCH_SETUP echo NO BRANCH SETUP
choice /C YN /M "Ready?" /T 300 /D N
if ERRORLEVEL 2 (
set ERROR_MSG=You said 'naw'
goto error
)

rem first, a little house cleaning
call c:\scripts\cleanGitRej.cmd
@echo %doEcho%
if not defined NO_BRANCH_SETUP call %scriptsdir%\setupBranch.cmd noPull %NO_STASH%
if ERRORLEVEL 1 set ERROR_MSG="Branch setup failed"
if defined ERROR_MSG goto error

call ant %ANT_TASKS%
rem - apply demo data: jar -xvf \GITRoot\iiq-test\demodata\previousVersions\[filename].zip
pushd build
if exist %IIQ_DEMO_DATA% %JAVA_HOME%\bin\jar -xvf %IIQ_DEMO_DATA%

rem - create database DDL: iiq schema
pushd WEB-INF\bin
call iiq.bat schema

rem - convert DDL to use tag 'iiq[version]_b[bugNumber]'
popd
popd
call %SCRIPT_HOME%\workstationutil.cmd convertDDL %REPO_HOME%\build %IIQ_TAG%

endlocal & set PATH=%PATH%& set JAVA_HOME=%JAVA_HOME%
goto end

:noDemoData
echo %IIQ_DEMO_DATA% is not available.  You'll have to manually implement it 1>&2
goto end

:error
echo %ERROR_MSG% 1>&2
endlocal
exit /b 1
goto end



:end
