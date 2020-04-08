@if not defined doEcho set doEcho=off
@echo %doEcho%

if [%1]==[] (
    echo A major version or 'develop' must be passed in!
    exit /b 1
)
rem set the defaults first and then process the switch
rem So the first call to switch_6.4 is in the event I call this using
rem a version that i've not defined. My assumption is that it's new and
rem I've not yet updated this script to accomodate.
call :switch_develop >nul 2>&1
call :switch_%1 >nul 2>&1
goto eof
rem %1 has the version
rem 
rem define a mapping between versions and JDK/node versions
rem Default on JDK 7 / Node 0.12.7

:switch_
echo naw, we shouldn't be here
goto eof

:switch_develop
:switch_7.3
call %scriptsdir%\switchjdk 8
call %scriptsdir%\switchnode 5
goto eof

:switch_7.2
:switch_7.1
call %scriptsdir%\switchjdk 7
call %scriptsdir%\switchnode 0
goto eof

:switch_7.0
:switch_6.4
call %scriptsdir%\switchjdk 6
call %scriptsdir%\switchnode 0
goto eof


:eof
