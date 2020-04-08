@echo off
pushd c:\GITRoot
for /f %%i in ('call %scriptsdir%\listGitRepos.cmd') do call :status %%i
popd
goto end

:status
pushd %1
echo.
echo %CD%
call git status
popd


:end
