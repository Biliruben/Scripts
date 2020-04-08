@if [%doEcho%]==[] set doEcho=off
@echo %doEcho%
setlocal EnableDelayedExpansion

set NODE0=c:\Program Files\nodejs-0.12.7
set NODE5=c:\Program Files\nodejs-5.12.0
set NODE8=c:\Program Files\nodejs-8.11.3

:: Clear CHOICE
set CHOICE=
if [%1]==[] goto cmdLineDone
:: Else %1 is something, but what?
set /a CHOICE=%1+0 2>nul
:: If there was an error, it's NOT an integer. Set CHOICE to the literal value
if ERRORLEVEL 1 set CHOICE=%1
:: There may not have been an error and weird math was attempted... so one
:: last try
if %CHOICE% LEQ 0 set CHOICE=%1

:: Remap some choices
if %CHOICE%==develop set CHOICE=8
if %CHOICE%==7.2 set CHOICE=0
if %CHOICE%==7.1 set CHOICE=0
if %CHOICE%==7.0 set CHOICE=0

:: Preserve the path in case user is stupid
set _path=%path%
call %scriptsdir%\log.cmd _path = "%_path%"

:cmdLineDone
call %scriptsdir%\log.cmd Choice [pre Input]="%CHOICE%"
:: Convenience utility script to switch up the node package in the path

if not defined CHOICE set /p CHOICE=Which NodeJS version? [0, 5, 8]: 
call %scriptsdir%\log.cmd Choice [post Input]="%CHOICE%"

:: Set the selected target value
set _node=!NODE%CHOICE%!
if not defined _node goto validate
:: Do all three nodes; One is a noop
set PATH=!PATH:%NODE0%=%_node%!
set PATH=!PATH:%NODE5%=%_node%!
set PATH=!PATH:%NODE8%=%_node%!

:: Validate
:validate
call %scriptsdir%\log.cmd "%PATH%"
call node --version
if ERRORLEVEL 1 set PATH=%_path%
endlocal & set PATH=%PATH%

