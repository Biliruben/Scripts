@if defined doEcho (
    @echo %doEcho%
) else (
    @echo off
)

rem Copy utility that deep copies files with the archive bit set
rem Unsets the bit upon copy
rem Reads from the file provided in %1
rem Copies to the directory provided in %2

rem Set Debug == "echo" to output the commands
rem Set Debug ==   to put back into 'live' mode
set DEBUG=

rem enable echo
if defined DEBUG call :processDebug


set FILE=%~1
set ON_ERROR=no

if not exist %FILE% call :error "Could not find %FILE%"
if /i %ON_ERROR% NEQ no exit /b 1

for /f "delims=, tokens=1,2" %%i in (%FILE%) do call :xcopyLine "%%i" "%%j"

rem done!
goto :eof

:xcopyLine
set src=%1
set dest=%2
%DEBUG% xcopy /m /e /c /i /f /g /h /r /y /exclude:toExclude.txt %src% %dest%
goto EOF

:createDirectory
echo Creating directory %*
%DEBUG% mkdir "%*"
goto EOF

:processDebug
@echo Debug flag set!
@echo on
set DEBUG=echo
goto EOF

:error
@echo %*
set ON_ERROR=yes
goto :eof

:eof
