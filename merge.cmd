@echo off
:mergeLoop
set HASH=%1
if not defined HASH goto :status
    echo Merging %HASH%
    if exist %HASH% goto mergePatch
    git log -n 1 %HASH%
    git show --pretty="format:" --name-only %HASH%
    rem git apply --reject option allows apply to apply as much as it can and reject what it can't
    git diff -b %HASH%~1 %HASH% | git apply --reject --verbose
    if ERRORLEVEL 1 exit /B 1
    shift
    goto :mergeLoop

:mergePatch
rem The hash we got is actually a file, merge that instead
git apply --reject --verbose %HASH%
goto end

:status
git status

:end
