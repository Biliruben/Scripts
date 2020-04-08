if defined doEcho @echo %doEcho%
rem This is a common utility method to setup the environment for the git related
rem scripts to properly operate.
rem
rem Do not use setlocal in this script, others should wrap this with that

set pause=
if defined git_remote (
    echo GIT_REMOTE already set! -- %git_remote%
    set pause=pause
)
if defined local_branch (
    echo LOCAL_BRANCH already set! -- %local_branch%
    set pause=pause
)
if defined pull_branch (
    echo PULL_BRANCH already set! -- %pull_branch%
    set pause=pause
)
if defined pause (
    echo 
    pause
)



set IIQ_VERSION=%1
for /f "delims=. tokens=1,*" %%i in ('echo %IIQ_VERSION%') do set IIQ_VERSION_NO_DOT=%%i%%j
set IIQ_BUG=%2
if not defined REPO_HOME set REPO_HOME=%CD%
if not defined ANT_TASKS set ANT_TASKS=clean,dist
set ANT_HOME=c:\ant
set SCRIPT_HOME=c:\scripts
set IIQ_TEST_HOME=c:\GITRoot\iiq-test
set IIQ_DEMO_DATA=%IIQ_TEST_HOME%\demodata\previousVersions\DemoData-%IIQ_VERSION%.zip
set IIQ_TAG=iiq%IIQ_VERSION_NO_DOT%p_c%IIQ_BUG%

if not defined git_remote (
set git_remote=remotes/origin/%IIQ_VERSION%p-develop
    if /I develop EQU %IIQ_VERSION% (
        set git_remote=remotes/origin/develop
    )
)
if not defined local_branch (
set local_branch=tkirk/case%IIQ_BUG%-%IIQ_VERSION%p
    if /I develop EQU %IIQ_VERSION% (
        set local_branch=tkirk/bug%IIQ_BUG%-develop
    )
)
if not defined pull_branch (
set pull_branch=%IIQ_VERSION%p-develop
    if /I develop EQU %IIQ_VERSION% (
        set pull_branch=develop
    )
)

if /I develop EQU %IIQ_VERSION% (
set IIQ_TAG=iiqdev_b%IIQ_BUG%
)
