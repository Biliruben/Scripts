@call doEcho

setlocal
rem the number of commits to look back on
set CHECK_COMMITS=3
set SEARCH_TERM=%1
if [%SEARCH_TERM%] EQU [] goto noSearchTerm

echo Searching for "%SEARCH_TERM%"
rem For each repo
rem
for /f "usebackq" %%i in (`call %SCRIPT_HOME%\listGitRepos.cmd`) do call :doRepo %%i

rem Get a list of efix branches
rem
:doRepo
set repo=%GIT_HOME%\%1
if not exist %repo% (
    echo %repo% does not exist
    goto eof
)
echo Moving to %repo%
pushd %repo%
for /f "usebackq" %%i in (`git branch -l *efix*`) do call :doBranch %%i
popd
goto eof

rem For each branch
rem
:doBranch
set branch=%1
if %branch% EQU * goto eof
echo Checking branch %branch%
for /f "usebackq" %%i in (`git log -%CHECK_COMMITS% --pretty^=format:"%%h" %branch%`) do call :doCommit %%i
goto eof


rem Get a list of files from last 3? commits and flag any that
rem have an *searchTerm*java in it
:doCommit
set commit=%1
git show --name-only %commit% | findstr /c:%SEARCH_TERM% /i > nul
if ERRORLEVEL 1 goto eof
echo.
echo Found in %branch%:%commit%
git show --name-only %commit%
echo.
goto eof

:noSearchTerm
echo No search term provided
goto eof

:eof
