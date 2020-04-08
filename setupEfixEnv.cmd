if defined doEcho @echo %doEcho%
rem This is a common utility method to setup the environment for the git related
rem scripts to properly operate.
rem
rem Do not use setlocal in this script, others should wrap this with that

set pause=
if defined GIT_REMOTE (
    echo GIT_REMOTE already set! -- %GIT_REMOTE%
    set pause=pause
)
if defined LOCAL_BRANCH (
    echo LOCAL_BRANCH already set! -- %LOCAL_BRANCH%
    set pause=pause
)
if defined PULL_TAG (
    echo PULL_TAG already set! -- %PULL_TAG%
    set pause=pause
)
if not defined JIRA_PREFIX (
    echo JIRA_PREFIX isn't defined! Using default: efix
    set JIRA_PREFIX=efix
    set pause=pause
)

if defined pause (
    echo 
    pause
)



set IIQ_VERSION=%1
set IIQ_EFIX=%2
if not defined REPO_HOME set REPO_HOME=%CD%
rem no need to Dist; User has to jack with the properties file and build anyways
if not defined ANT_TASKS set ANT_TASKS=clean
set ANT_HOME=c:\ant
set SCRIPT_HOME=c:\scripts

if not defined PULL_TAG (
    set PULL_TAG=GA_%IIQ_VERSION%
)

if not defined GIT_REMOTE (
    set GIT_REMOTE=tags/%PULL_TAG%
)

if not defined LOCAL_BRANCH (
    set LOCAL_BRANCH=efix/tkirk/%JIRA_PREFIX%%IIQ_EFIX%-%IIQ_VERSION%
)

if not defined IIQ_TAG set IIQ_TAG=iiq%IIQ_VERSION%_f%IIQ_EFIX%
