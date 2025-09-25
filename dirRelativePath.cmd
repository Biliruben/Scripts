@echo off
setlocal EnableDelayedExpansion
set dir=%CD%
if [%1] NEQ [] set dir=%1

for /R %%i in (%dir%) do call :listRelative "%%i"
goto eof

:listRelative
set file=%~1
set relativeFile=!file:%dir%\=!
echo %relativeFile%
goto eof

:eof
