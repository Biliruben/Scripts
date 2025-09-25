@call %SCRIPT_HOME%\doEcho.cmd
rem Uses a "branches.txt" file to read in
rem Version,TAG,committish
rem
rem Version - version to "switch" to
rem TAG - What tag to checkout
rem committish - hash/branch to cherry-pick for the "Efixins" commit
rem
rem Must execute from a git repo

setlocal
if [%1] EQU [] goto noFile
set branchesFile=%~1

if not exist .git goto noRepository

rem g2g - just validate from the user if the branches file looks good
for /f "tokens=1,2,3 delims=," %%i in (%branchesFile%) do echo %%i %%j %%k

choice /C YN /M "Ready?" /T 300 /D N
if ERRORLEVEL 2 goto notReady

for /f "tokens=1,2,3 delims=," %%i in (%branchesFile%) do call :doBranch %%i %%j %%k



endlocal
goto eof

:doBranch
set version=%1
set tag=%2
set branch=%3

call switchiiq %version%
call ant clean
call git checkout -f %tag%
if ERRORLEVEL 1 goto gitError
call git cherry-pick --no-commit %branch%
if ERRORLEVEL 1 goto gitError
call ant autobuild-efix
goto eof

:gitError
echo Git error, aborting
exit /B 1
goto eof

:noFile
echo No "branches" file passed in
goto eof

:noRepository
echo Not in a git repository root
goto eof

:notReady
echo You said 'naw'
goto eof

:eof
