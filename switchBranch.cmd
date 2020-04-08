@echo off
setlocal
rem Required parameters: target branch,
set BRANCH=%1
git branch | findstr /c:%BRANCH%
if ERRORLEVEL 1 goto noFind

rem Stash current changes
rem Let it use the default message
git stash save

rem Switch to the desired branch
git checkout -f %BRANCH%

rem Pop the stash, if exists
for /f "delims=: tokens=1,*" %%i in ('git stash list ') do call :findStash %%i "%%j"
if defined IIQ_STASH git stash pop %IIQ_STASH%

rem
rem clean,dist,weave
ant clean,dist,weave-aspects

goto end

:findStash
rem don't do anything if the stash has already been set
if defined IIQ_STASH goto end
set stash=%1
set msg=%2
set iiqVersionP=%IIQ_VERSION%p
echo %msg% | findstr /c:"%BRANCH%" > NUL
if not ERRORLEVEL 1 set IIQ_STASH=%stash%
goto end

:noFind
echo Could not find branch %BRANCH%
endlocal
exit 1
goto end

:exit
endlocal
goto end

:end
