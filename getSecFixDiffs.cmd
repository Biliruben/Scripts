@call %SCRIPT_HOME%\doEcho.cmd

REM Given a list of files and a list of commit differences,
REM determine what diffs there are for each file

setlocal
set FILE_LIST=%~f1
set COMMITS_LIST=%~f2
if not defined REPO_HOME set REPO_HOME=c:\GITRoot\iiq-ssh-local

if [%3] NEQ [] set REPO_HOME=%3

if not defined FILE_LIST goto usage
if not defined COMMITS_LIST goto usage
if not exist "%FILE_LIST%" goto fileNotFound %FILE_LIST%
if not exist "%COMMITS_LIST%" goto fileNotFound %COMMITS_LIST%

pushd %REPO_HOME%
for /f "usebackq" %%i in ("%FILE_LIST%") do call :diffFile "%%i"
popd

goto eof

:diffFile
for /f "usebackq" %%j in ("%COMMITS_LIST%") do call :gitDiff %1 %%j
goto eof

:gitDiff
set diffFile=%~1
set diffCommits=%~2
echo Diffing %diffFile% in %diffCommits%
call git diff --compact-summary %diffCommits% %diffFile%
goto eof

:usage
echo.
echo Two arguments required:
echo $ %0 listOfFiles.txt listOfCommitDiffs.txt [c:\GITRoot\iiq-ssh-local]
goto eof

:fileNotFound
echo.
echo %1 could not be found
goto usage

:eof
