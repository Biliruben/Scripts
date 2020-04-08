@setlocal
@echo off
REM Finds Git artifacts related to a given bug
set ERROR_MSG=
if "%~1"=="" set ERROR_MSG=Bug number must be passed
if defined ERROR_MSG goto error
set BUG=%1
if not defined GIT_HOME set GIT_HOME=c:\GITRoot
if not defined GIT_REPOS set GIT_REPOS=[iiq-ssh-local][dupe-iiq-ssh][iiq-ssh-2]

for /f %%i in ('call listGitRepos.cmd full') do call :checkRepo "%%i"

endlocal
goto end

:checkRepo
set repo=%~1
echo Checking %repo%
pushd %repo%
git stash list --pretty=oneline | findstr /i /c:%BUG%
git branch | findstr /i /c:%BUG%
echo.
popd
goto end

:error
echo %ERROR_MSG%
exit /b 1

:end
