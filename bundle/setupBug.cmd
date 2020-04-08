@set doEcho=off
@echo %doEcho%
set ERROR_MSG=
if "%~1"=="" set ERROR_MSG=Two parameters must be passed: The IIQ Version and the Bug Number
if "%~2"=="" set ERROR_MSG=Two parameters must be passed: The IIQ Version and the Bug Number
if defined ERROR_MSG goto error
rem Setup SSH agent
rem Do this before setlocal so the env vars stick
if not DEFINED SSH_AGENT_PID call %scriptsdir%\setupGitSSH.cmd
setlocal
if not "%~3"=="" set MERGE_HASH=%3

rem setup our env vars
call %scriptsdir%\setupBugEnv.cmd %*

rem A little opp for our caller to complain
cd /d %REPO_HOME%
echo Finding previous instances of bug: %IIQ_BUG%
call %scriptsdir%\findbug.cmd %IIQ_BUG%
echo Current branch status:
git status
git bugz
echo.
echo IIQ_VERSION=%IIQ_VERSION%
echo IIQ_BUG=%IIQ_BUG%
if defined MERGE_HASH echo MERGE_HASH=%MERGE_HASH%
echo ANT_HOME=%ANT_HOME%
echo SCRIPT_HOME=%SCRIPT_HOME%
echo IIQ_TEST_HOME=%IIQ_TEST_HOME%
echo IIQ_DEMO_DATA=%IIQ_DEMO_DATA%
echo REPO_HOME=%REPO_HOME%
echo IIQ_TAG=%IIQ_TAG%
echo.
choice /C YN /M "Ready?" /T 300 /D N
if ERRORLEVEL 2 (
set ERROR_MSG=You said 'naw'
goto error
)

rem first, a little house cleaning
call c:\scripts\cleanGitRej.cmd

call %scriptsdir%\setupBranch.cmd
if ERRORLEVEL 1 set ERROR_MSG="Branch setup failed"
if defined ERROR_MSG goto error

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

rem - import database DDL: mysql < \GITRoot\iiq-ssh-local\build\web-inf\database\create*mysql
rem I assume you have mysql in the path AND it auto-configured with auth
echo Dropping DB %IIQ_TAG%
mysql -e "drop database if exists %IIQ_TAG%"
echo Importing database DDL
mysql < build\WEB-INF\database\create_identityiq_tables.mysql

rem - init iiq
if not exist %IIQ_DEMO_DATA% goto noDemoData
echo Initializing IIQ with DemoData
pushd build\web-inf\bin
call %SCRIPT_HOME%\initiiq.cmd
popd

rem - Last thing: if we had a hash to merge, git status
if defined MERGE_HASH git status

endlocal
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
