if defined doEcho @echo %doEcho%
rem This is a common utility method to setup the environment for the git related
rem scripts to properly operate.
rem
rem Do not use setlocal in this script, others should wrap this with that


if not defined pause set pause=
if defined git_remote (
    echo GIT_REMOTE already set! -- %git_remote%
    set pause=pause
)
if defined local_branch (
    echo LOCAL_BRANCH already set! -- %local_branch%
    set pause=pause
)
if defined local_branch_prefix (
    echo LOCAL_BRANCH_PREFIX already set! -- %local_branch_prefix%
    set pause=pause
)
if defined pull_branch (
    echo PULL_BRANCH already set! -- %pull_branch%
    set pause=pause
)
if defined pause (
    echo.
    echo %SCRIPT_HOME%\clearBugEnv.cmd will clear these values
    echo.
    if not defined noPause (
        echo 
        pause
    )
)
if [%doEcho%]==[on] echo JIRA_PREFIX=%JIRA_PREFIX%
if not defined JIRA_PREFIX call :chooseJiraPrefix
call :setJiraTagPrefix



set IIQ_VERSION=%1
for /f "delims=. tokens=1,*" %%i in ('echo %IIQ_VERSION%') do set IIQ_VERSION_NO_DOT=%%i%%j
set IIQ_BUG=%2
if not defined REPO_HOME set REPO_HOME=%CD%
if not defined ANT_TASKS set ANT_TASKS=clean,dist
if not defined ANT_HOME set ANT_HOME=c:\ant
if not defined SCRIPT_HOME set SCRIPT_HOME=c:\scripts
if not defined GIT_HOME set GIT_HOME=c:\GITRoot
if not defined IIQ_TEST_HOME set IIQ_TEST_HOME=%GIT_HOME%\iiq-test
if not defined IIQ_DEMO_DATA set IIQ_DEMO_DATA=%IIQ_TEST_HOME%\demodata\previousVersions\DemoData-%IIQ_VERSION%.zip

rem Set the init Import
if not defined INIT_IMPORT_FILE (
    rem Do the "else" clause as the default
    set INIT_IMPORT_FILE=c:\scripts\initIIQ-import.iiq
    rem 8.4 import version
    if %IIQ_VERSION_NO_DOT% GEQ 84 set INIT_IMPORT_FILE=c:\scripts\initIIQ-import84.iiq
)
if not defined pull_branch (
    set pull_branch=%IIQ_VERSION%p-develop
    if /I develop EQU %IIQ_VERSION% (
        set pull_branch=develop
    )
)

if not defined local_branch_prefix set local_branch_prefix=tkirk

if not defined git_remote (
    set git_remote=remotes/origin/%pull_branch%
)

if not defined local_branch (
    if defined IIQ_TAG (
        set local_branch=%local_branch_prefix%/%IIQ_TAG%
    ) else (
        set local_branch=%local_branch_prefix%/%JIRA_PREFIX%%IIQ_BUG%-%IIQ_VERSION%p
        if /I develop EQU %IIQ_VERSION% (
         set local_branch=%local_branch_prefix%/%JIRA_PREFIX%%IIQ_BUG%-develop
        )
    )
)

if /I develop EQU %IIQ_VERSION% (
    if not defined IIQ_TAG set IIQ_TAG=iiqdev_%tagPrefix%%IIQ_BUG%
) else (
    if not defined IIQ_TAG set IIQ_TAG=iiq%IIQ_VERSION_NO_DOT%p_%tagPrefix%%IIQ_BUG%
)
REM This is so fucking stupid. Because the PATH variable has "(x86)" we can't 
REM include this statement within a block statement because it uses ( ) to define
REM the block. And shit blows up. I really need to move past CMD batch scripts
if /I develop EQU %IIQ_VERSION%  set PATH=%JAVA_HOME%\bin;%PATH%

REM setupBug wants to search for previous branches, give it a better search term
REM ideally, iiq[prefix]nnn
set bugSearchTerm=%JIRA_PREFIX%%IIQ_BUG%

goto eof

:chooseJiraPrefix
    rem echo JIRA_PREFIX isn't defined! Using default: iiqetn
    echo JIRA_PREFIX not defined:
    echo    E - ETN (iiqetn)
    echo    T - Twin Creeks (iiqtc)
    echo    S - Star Ranch (iiqsr)
    echo    Z - Set (set)
    echo    X - Efix (efix)
    choice /C ETSZX /T 15 /D E
    if errorlevel 5 (
        set JIRA_PREFIX=EFIX
    ) else if errorlevel 4 (
        set JIRA_PREFIX=SET
    ) else if errorlevel 3 (
        set JIRA_PREFIX=IIQSR
    ) else if errorlevel 2 (
        set JIRA_PREFIX=IIQTC
    ) else (
        rem Default IIQETN
        set JIRA_PREFIX=IIQETN
    )
goto eof

:setJiraTagPrefix
call %scriptsdir%\applyJiraPrefixToTag.cmd
goto eof


:eof
