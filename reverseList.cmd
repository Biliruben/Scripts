@echo off
rem Reverses the incoming file.  If no incoming file, then reverses
rem the list in the environment variable REVERSE_LIST.  Note, list can
rem be a multi-line value (good luck on that) or a single value with
rem line delimiters !LF!

rem Define the newline.  NOTE: There MUST be an empty line afterwards
setlocal EnableDelayedExpansion
set LF=^


rem DO NOT PUT ANYTHING ABOVE THIS LINE OR REMOVE ANY EMPTY LINE ABOVE
set REVERSE_LIST=
set FILE=%1
if [%FILE%] equ [] goto processMemory
goto processFile

:processMemory
rem when processing memory, we echo the result directly out
for /f "delims=" %%i in ('echo %LIST%') do call :prependList "%%i"
echo %REVERSE_LIST:--~~=~%
goto end

:processFile
for /f "delims=" %%i in (%FILE%) do call :prependList "%%i"
echo %REVERSE_LIST:--~~=!%>%FILE%
rem type %FILE%
goto end


:prependList
set LINE=%*
if not defined REVERSE_LIST (
    set REVERSE_LIST=%LINE%--~~LF--~~
) else (
    set REVERSE_LIST=%LINE%--~~LF--~~%REVERSE_LIST%
)

goto end

:end
