@echo off
setlocal
set MAX=32767
set MIN=1
set LIMIT=%DEFAULT_LIMIT%
if NOT "%~1"=="" set LIMIT=%1
if NOT "%~2"=="" set MIN=%2
set rand=%RANDOM%*%LIMIT%/%MAX%+%MIN%
exit /b %rand%
