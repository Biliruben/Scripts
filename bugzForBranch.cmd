@echo off
REM Shows last commit for each branch found for a given bug
setlocal
set ERROR_MSG=
if "%~1"=="" set ERROR_MSG=Bug number must be passed
if defined ERROR_MSG goto error
set BUG=%1
if not defined GIT_HOME set GIT_HOME=c:\GITRoot
if not defined GIT_REPOS set GIT_REPOS=[iiq-ssh-local][dupe-iiq-ssh][iiq-ssh-2]

for /f %%i in ('call c:\scripts\listGitRepos.cmd full') do call :checkRepo "%%i"

endlocal
goto end

:checkRepo
set repo=%1
echo.
echo ################################################
echo Checking %repo%
pushd %repo%
for /f %%j in ('git branch ^| findstr /c:%BUG%') do (
    echo %%j
    git bugz %%j
    echo ________________________________________________
)
popd
goto end


:error
echo %ERROR_MSG%
exit /b 1

:end
