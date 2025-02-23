@if defined doEcho (
    @echo %doEcho%
) else (
    @echo off
)

REM Reconciles my local repository to GitHub, specifically purging out of
REM date branches from both locations.
REM
REM Step 1: Find branches representing a closed bug, run through cleanBug
REM Turns out, I only need the one step

rem call setupGitSSH.cmd

set executionId=%RANDOM%
set TEMP_BUG_FILE=%temp%\_bugs.%executionId%
set TEMP_BRANCH_FILE=%temp%\_branches.%executionId%
set TEMP_BRANCH_BUG_FILE=%temp%\_bug-branches.%executionId%


:step1
REM This needs to be updated to get closed JIRA tickets
call c:\scripts\runBugzQuery c:\scripts\sql\closedBugs.sql > %TEMP_BUG_FILE%

rem pull our list of branches
for /f "delims=" %%i in ('call c:\scripts\listGitRepos.cmd full') do call :getBranches %%i
@echo %ECHO_LEVEL%

rem for each closed bug, see if we have a branch that matches
for /f "tokens=1" %%i in (%TEMP_BUG_FILE%) do call :findBug %%i

if not exist %TEMP_BRANCH_BUG_FILE% goto :finish
rem for each bug in bug-branches, run through cleanBug
if %ECHO_LEVEL% EQU on (
    set forceClean=n
) else (
    set forceClean=y
)
for /f "delims=" %%i in (%TEMP_BRANCH_BUG_FILE%) do call c:\scripts\cleanBug.cmd %%i %forceClean%
goto :finish

:finish
rem Cleaning our mess up
call :cleanFile "%TEMP_BUG_FILE%"
call :cleanFile "%TEMP_BRANCH_FILE%"
call :cleanFile "%TEMP_BRANCH_BUG_FILE%"
rem jump to end, we're done.
goto end

:cleanFile
set file=%~1
rem Delete our file, but only if we're not in debug mode
if %ECHO_LEVEL% EQU off (
    rem How we do 'and' operations
    if exist %file% del /q "%file%"
)
goto end

:findBug
set bug=%1
findstr /c:bug%bug%- %TEMP_BRANCH_FILE% > nul
if ERRORLEVEL 1 goto end
rem found one
echo %bug% >> %TEMP_BRANCH_BUG_FILE%
goto end


:getBranches
set gitDir=%*
pushd "%gitDir%"
rem First, a little house cleaning: prune stale remote references
echo Pruning %CD%
call git remote prune origin
call git branch | findstr /c:"tkirk/" >> %TEMP_BRANCH_FILE%
rem This will get executed per git repo and create dupes in our file, but that's ok
call git branch -r | findstr /c:"tkirk/" >> %TEMP_BRANCH_FILE%
popd
goto end

:end
