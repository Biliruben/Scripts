@if "%doEcho%"=="" (
    @echo off
) else (
    @echo %doEcho%
)
setlocal
:: bad habit, but i wanted to use getOpts just to use getOps, and
:: now I want to work around it
set options=%*
if "%2" == "" set "options=-branch %1"
call log options = %options%
call SetScriptId
set _tempFile=%temp%\envScript_%ScrID%.cmd
:: Even if we are debugging, we can't run this with echo on
set _oldEcho=%doEcho%
set doEcho=off
call %scriptsdir%\getOpts.cmd "-branch:unset" %options% > %_tempFile%
if ERRORLEVEL 1 goto getOptsError
set doEcho=%_oldEcho%
echo %doEcho%
if not exist %_tempFile% goto envNotFound
call %_tempFile%
del /q %_tempFile%

if "%-branch%"=="unset" goto branchUnset

:: got a branch, let's go find it
for /f %%i in ('call listGitRepos.cmd full') do call :checkRepo "%%i"

endlocal
goto end

:checkRepo
set repo=%1
echo Checking %repo% for branch %-branch%
pushd %repo%
git branch | findstr /i /c:%-branch%
echo.
popd
goto end


:getOptsError
echo Error running getOpts. Captured this output from %_tempFile%:
type %_tempFile%
goto usage

:envNotFound
echo getOpts environment file not found!
echo file: %_tempFile%
goto usage

:branchUnset
echo Branch not passed in
goto usage


:usage
echo Usage: %0 -branch branch_to_find
exit /b 1


:end
