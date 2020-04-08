@if not defined doEcho set doEcho=off
@echo %doEcho%

if [%1]==[] (
    echo A 1 or a 2 ^(maybe a 3, someday^) is required
    exit /b 1
)
rem Switches the cmd prompt to make it obvious which git repo
rem I'm intending to work out of
call :switch_%1
goto eof
:switch_
echo naw, we shouldn't be here
goto eof

:switch_1
rem set COLOR_HEX to nothing to reset to 'system default'
set COLOR_HEX= 
set CMD_TITLE=C:\WINDOWS\system32\cmd.exe
goto switch_it

:switch_2
set COLOR_HEX=0A
set CMD_TITLE=C:\WINDOWS\system32\cmd.exe - iiq-ssh-2
goto switch_it

:switch_it
color %COLOR_HEX%
title %CMD_TITLE%
goto eof

:eof
