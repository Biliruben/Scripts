@setlocal
@echo off
REM Lists the git repositories as defined by environment variables
if [%1] EQU [full] set FULL_PATH=true

for /f %%i in ('dir /b /ad %GIT_HOME%') do call :checkRepo %%i
endlocal

goto end

:checkRepo
echo %GIT_REPOS% | findstr /c:[%1] > nul
if ERRORLEVEL 1 goto end
rem did you get here?  You found one!
if defined FULL_PATH (
    set REPO_PATH=%GIT_HOME%\%1
) else (
    set REPO_PATH=%1
)
echo %REPO_PATH%
goto end

:end
