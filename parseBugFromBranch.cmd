@echo off
REM Given the output of git status, parse the bug number
REM from the branch name when a known format is used
REM

setlocal
for /f %%i in ('git rev-parse --abbrev-ref HEAD') do call :parseBug %%i
if defined parsedBug echo %parsedBug%
goto end


:parseBug
set fullBranchName=%1
for /f "delims=tkirk/bug" %%i in ("%fullBranchName%") do (
    for /f "delims=-" %%j in ("%%i") do (
        rem Validate that we have a 'number' and not a random word
        set parsedBug=%%j
    )
)


:end
