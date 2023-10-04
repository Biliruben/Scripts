@echo off
if [%1] EQU [] goto noDB
setlocal
set DBS_TO_BACKUP=%*
set SQL_FILE=%1.sql
if exist %SQL_FILE% goto backupExists
echo Exporting %DBS_TO_BACKUP% to %SQL_FILE%
mysqldump --add-drop-database --databases %* > %SQL_FILE%
endlocal
goto eof

:noDB
echo No database specified:
echo %0 database1 [database2] [database3]
exit /b 1

:backupExists
echo %SQL_FILE% already exists!
exit /b 2

:eof
