@call doEcho
if [%1] EQU [] goto :noFile
setlocal
set GZ_BIN=c:\gzip-1.3.12-1-bin\bin\gzip.exe
set fileName=%~1
call %GZ_BIN% -d "%fileName%"
goto eof

:noFile
echo.
echo No file specified!
goto usage

:usage
echo %0 fileName.gz
goto eof

:eof
