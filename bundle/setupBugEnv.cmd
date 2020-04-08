if defined doEcho @echo %doEcho%
rem This is a common utility method to setup the environment for the git related
rem scripts to properly operate.
rem
rem Do not use setlocal in this script, others should wrap this with that

set IIQ_VERSION=%1
for /f "delims=. tokens=1,*" %%i in ('echo %IIQ_VERSION%') do set IIQ_VERSION_NO_DOT=%%i%%j
set IIQ_BUG=%2
if not defined REPO_HOME set REPO_HOME=%CD%
set ANT_HOME=c:\ant
set SCRIPT_HOME=c:\scripts
set IIQ_TEST_HOME=c:\GITRoot\iiq-test
set IIQ_DEMO_DATA=%IIQ_TEST_HOME%\demodata\previousVersions\DemoData-%IIQ_VERSION%.zip
set IIQ_TAG=iiq%IIQ_VERSION_NO_DOT%p_b%IIQ_BUG%

set git_remote=remotes/origin/%IIQ_VERSION%p-develop
set local_branch=tkirk/bug%IIQ_BUG%-%IIQ_VERSION%p
set pull_branch=%IIQ_VERSION%p-develop

if /I develop EQU %IIQ_VERSION% (
set git_remote=remotes/origin/develop
set local_branch=tkirk/bug%IIQ_BUG%-develop
set IIQ_TAG=iiqdev_b%IIQ_BUG%
set pull_branch=develop
)

