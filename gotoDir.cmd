@call %SCRIPT_HOME%\doEcho.cmd
rem Cheater script to hop-to some of my commonly visitied directories
rem Usge: goto [slug] - slug is a partial directory name, ideally starts-with
rem     We'll look in a few "Known families" of directories to find the target
rem     dir and pushd into it

setlocal

if [%1] EQU [] goto noSlug
set SLUG=%1

set SEARCH_DIRS_FILE=%SCRIPT_HOME%\gotoDirs.txt
set PUSHD_DIR=
if not exist %SEARCH_DIRS_FILE% goto noDirsFile
for /f %%i in (%SEARCH_DIRS_FILE%) do call :gotoDir %%i

if defined PUSHD_DIR endlocal & pushd %PUSHD_DIR%
goto eof

:gotoDir
set baseDir=%1
if exist "%baseDir%\%SLUG%*" set PUSHD_DIR="%baseDir%\%SLUG%*"

goto eof


:noDirsFile
echo Directory list file was not found: %SEARCH_DIRS_FILE%
goto eof

:noSlug
echo No target directory provided
echo    usage: goto baseDirName
goto eof

:eof
