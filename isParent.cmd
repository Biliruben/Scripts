@echo off
setlocal
set parent=%1
set child=%2

git rev-list %parent% | findstr /c:%child% > nul
if errorlevel 1 (
    echo Not found.
) else (
    echo Found! %parent% is a parent of %child%
)
endlocal
