if defined doEcho @echo %doEcho%
rem Sets up the git branch by checking it out, linking it to origin, and pulling 
rem new commits.  It will also apply the applicable stash.
rem
rem This script needs to anticipate new branches and existing branches.
rem
rem Since this is a 'sub' script, we need to have certain environment variables
rem set.  Charge the caller with making sure this is done.

setlocal
call %SCRIPT_HOME%\SetScriptId.cmd
call %SCRIPT_HOME%\getCurrentDirectory.cmd
rem This is a tag; once created, the remote should never change. pulling is moo
rem if [%1]==[noPull] (
    rem set NO_PULL=true
rem ) else (
    rem set NO_PULL=false
rem )
rem Applying stashes may still be a thing.
if [%1]==[--noStash] (
    set NO_STASH=true
) else (
    set NO_STASH=false
)

set DIFF_DIRECTORY=c:\etn_data

if not defined local_branch set ERROR_MSG=%%local_branch%% must be defined
if defined ERROR_MSG goto error

cd /d %REPO_HOME%

rem This var left intentionlly blank
set IIQ_STASH=

rem configures the git environment for working on a new bug
rem
rem We follow these steps:
rem - Fetch the pull_branch (tag)
git fetch --prune origin %GIT_REMOTE%
if ERRORLEVEL 1 set ERROR_MSG=%GIT_REMOTE% not found!
if defined ERROR_MSG goto error

rem - checkout and switch branch: git checkout --no-track -b [local_branch] [pull_branch]

git checkout -f -B %local_branch% %GIT_REMOTE% 
if ERRORLEVEL 1 set ERROR_MSG=Checkout failed!
if defined ERROR_MSG goto error

rem Clean up any messes that need cleaning up
git gc --auto

rem If we didn't find a stash, merge our configuration diff instead
if not defined IIQ_STASH (
    echo No previous stash found, applying base configuration
    call :findMerge
) else (
    if %NO_STASH%==true (
        echo Stash application suppressed
        rem Unset IIQ_STASH so the base config is still applied
        set IIQ_STASH=
        call :findMerge
    ) else (
        echo Applying ^(git stash apply^) stash %IIQ_STASH%
        git stash apply %IIQ_STASH%
    )
)

rem Dead code; should never do this
if defined MERGE_HASH call :doMerge

rem - update iiq.properties: convert relevant attributes to 'iiq[version]_b[bugNumber]
rem Not in setupEfix! User has other things to do and we will not likely be running this build functionally
rem call %SCRIPT_HOME%\workstationutil.cmd convertIIQProperties %REPO_HOME%\src %IIQ_TAG%

rem - clean the build: ant clean
if not defined ANT_TASKS set ANT_TASKS=clean
call %ANT_HOME%\bin\ant %ANT_TASKS%
if ERRORLEVEL 1 set ERROR_MSG=Ant task failed!
if defined ERROR_MSG goto error

endlocal
goto end

:doMerge
echo Merging %MERGE_HASH%
rem call %SCRIPT_HOME%\merge.cmd %MERGE_HASH%
call git cherry-pick --no-commit %MERGE_HASH%
if ERRORLEVEL 1 call :error "Merge failed!"
goto end

:findBranchStash
if defined IIQ_STASH goto end
set stash=%1
set msg=%2
echo %msg% | findstr /c:"On %local_branch%:" > NUL
if not ERRORLEVEL 1 set IIQ_STASH=%stash%
rem Instead of making this search case insensitive or dealing with RegEx in windows, just do a second
echo %msg% | findstr /c:"on %local_branch%:" > NUL
if not ERRORLEVEL 1 set IIQ_STASH=%stash%
goto end

:findMerge
rem This should be a surpurfulous, but just in case
if defined IIQ_STASH goto end
rem applying the base config for a patch is easy: use develop's
set iiqVersionP=develop
rem Find the suggested diff and merge it
set diffFile=%DIFF_DIRECTORY%\%iiqVersionP%-BaseConfig.diff
echo Merging diff file: %diffFile%
rem Set your env variables outside of the weird 'if' block. In CMD,
rem scopes are fucking weird
set _tempDiff=%TEMP%\%BASE_CD%_%ScrID%.diff
echo tempDiff: %_tempDiff%
if exist "%diffFile%" (
    rem Do a search and replace of {GIT_REPO} into a temp difffile
    call sed "s/{GIT_REPO}/%BASE_CD%/g" %diffFile% > %_tempDiff%
    dos2unix %_tempDiff%
    git apply --whitespace nowarn --reject %_tempDiff%
    del /f /q %_tempDiff%
) else (
    echo Diff file not found!
    echo.
)
echo %msg% | findstr /c:"%iiqVersionP%-BaseConfig" > NUL
if not ERRORLEVEL 1 set IIQ_STASH=%stash%
goto end

:error
echo %ERROR_MSG% 1>&2
endlocal
exit /b 1
goto end


:end

