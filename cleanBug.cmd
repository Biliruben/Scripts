@if defined doEcho (
    @echo %doEcho%
) else (
    @echo off
)
set BUG=%1
REM Get a ScrID
call %SCRIPT_HOME%\SetScriptId.cmd
echo %ScrId%
if [%2]==[y] set FORCE=true
set SEARCH_STRING=tkirk/.*%BUG%
for /f %%i in ('call listGitRepos.cmd full') do call :main %%i
endlocal
goto end

:main
pushd %1
echo Finding related data for bug %BUG% in %CD%
git branch | findstr /r /c:"%SEARCH_STRING%"
set /a foundAnything=%ERRORLEVEL%
git branch -r | findstr /r /c:"%SEARCH_STRING%"
set /a foundAnything=%ERRORLEVEL% * %foundAnything%
git sl | findstr /r /c:"%SEARCH_STRING%"
set /a foundAnything=%ERRORLEVEL% * %foundAnything%

rem if 'foundAnyting' is 0, something was found
if %foundAnything% NEQ 0 goto end

rem set the Timeout to 2 minutes unless force is set
rem When force is set, timeout is reduced to 0 which
rem auto-selects the default value
set timeout=120
if defined FORCE set timeout=0
choice /m "Do you want to continue" /D y /T %timeout%
if ERRORLEVEL 2 goto userEnd
goto cont

:cont
set tempBranchListFileName=%TEMP%\_cleanBugBranchList_%ScrId%.txt
git branch | findstr /r /c:"%SEARCH_STRING%" > %tempBranchListFileName%
for /f %%i in (%tempBranchListFileName%) do call :deleteBranchIfBug %%i
git branch -r | findstr /r /c:"%SEARCH_STRING%" > %tempBranchListFileName%
for /f %%i in (%tempBranchListFileName%) do call :deleteRemoteBranchIfBug %%i
del /q %tempBranchListFileName%
set tempStashFile=%temp%\_stashList.%ScrID%
git stash list > %tempStashFile%
call reverseList %tempStashFile%
for /f "delims=~" %%i in (%tempStashFile%) do call :deleteStashIfBug %%i
del /q %tempStashFile%
popd
rem Purge the data
echo Finding databases...
for /f %%i in ('mysql -N -B -e "show databases"') do call :dropDatabaseIfBug %%i 
goto end

:dropDatabaseIfBug
echo %1 | findstr /r /c:"%BUG%" > NUL
if ERRORLEVEL 1 goto end
echo Dropping database %1 
mysql -N -B -e "drop database %1"
goto end


:deleteStashIfBug
echo %* | findstr /r /c:"%SEARCH_STRING%" > NUL
if ERRORLEVEL 1 goto end
rem finds the first token in the string, which is our stash
for /f "delims=:" %%i in ("%1") do set stash=%%i
if defined stash (
echo Deleting stash %stash%
git stash drop %stash%
)
goto end


:deleteRemoteBranchIfBug
set remoteBranch=%1
rem Drop the leading 'origin/' from the remote branch
set branch=%remoteBranch:origin/=%
set branchTest=%branch:tkirk/=%
echo :deleteRemoteBranchIfBug:%branch%:%branchTest%
rem Windows cmd way of doing a substring match.  If branchTest is the same string
rem as branch, then the string 'tkirk/' wasn't in branch.  If it wasn't in branch,
rem then this branch is special and deserves special attention.
if %branch% EQU %branchTest% goto end
echo %branch% | findstr /r /c:"%SEARCH_STRING%" > NUL
if ERRORLEVEL 1 goto end
echo Deleting branch %branch%
git push origin --delete %branch%
goto end

:deleteBranchIfBug
set branch=%1
set branchTest=%branch:tkirk/=%
echo :deleteBranchIfBug:%branch%:%branchTest%
rem Windows cmd way of doing a substring match.  If branchTest is the same string
rem as branch, then the string 'tkirk/' wasn't in branch.  If it wasn't in branch,
rem then this branch is special and deserves special attention.
if %branch% EQU %branchTest% goto end
echo %branch% | findstr /r /c:"%SEARCH_STRING%" > NUL
if ERRORLEVEL 1 goto end
echo Deleting branch %branch%
git branch -D %branch%
goto end

:userEnd
echo You chose not to continue.  Good for you.
popd
exit /b

:end
