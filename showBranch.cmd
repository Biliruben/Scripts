@echo off
REM Shows me my branch status and the bug details
REM
setlocal

REM First, determine the bug number
for /f %%i in ('call parseBugFromBranch') do (
    set bugNumber=%%i
)
echo Bug %bugNumber%

REM What branches have we created for this bug
call findBug %bugNumber%

REM How about that branch status now
git status

REM And the last thing we committed
git bugz

REM And finally remind me of the actual bug
call getBug %bugNumber%

