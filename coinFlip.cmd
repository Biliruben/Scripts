@echo off
setlocal
set max=%1
if []==[%2] (
    set risk=-65000
) else (
    set risk=%2
)
set total=0
for /l %%i in (1,1,%max%) do call :coinFlip
echo Total: %total%
endlocal
goto end

:coinFlip
rem Risk factor: if we've lost too much money, we probably want to stop now
if %total% LSS %risk% (
 echo No Bet!
 goto end
)
set seed=%RANDOM%
rem echo Initial seed: %seed%
set /a flip=%seed% * 2 / 32767
echo Flip: %flip%
if %flip% equ 0 set /a total=%total%-10
if %flip% equ 1 set /a total=%total%+20
goto end

:end
