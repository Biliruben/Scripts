@echo off
REM GIT script to cherry pick only if the repo isn't already
REM in a dirty cherry-pick state


if "%1"=="" goto noHash
set HASH=%1

git status --short | findstr /r "^DD|^AU|^UD|^UA|^DU|^AA|^UU"
if not ERRORLEVEL 1 goto noCherryPick
git cherry-pick -n %HASH%
goto end

:noHash
echo No hash provided
exit /b 1

:noCherryPick
echo Repository not ready for cherry-pick
exit /b 2

:end
