@echo off
setlocal
set SRC_FILE=%1
set ZIP_FILE=%~n1%~x1.zip
set DO_DELETE=false
if [%2] NEQ [] set DO_DELETE=%2
jar -cvfM "%ZIP_FILE%" "%SRC_FILE%"
if not ERRORLEVEL 1 (
    if /i %DO_DELETE% EQU y del /q %SRC_FILE%
)
