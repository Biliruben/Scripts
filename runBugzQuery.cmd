@setlocal
@echo off
set SQL_FILE=%1
if not exist %SQL_FILE% goto noFile

call mysql --defaults-file="c:\Program Files\MySQL\MySQL Server 5.5\bugz.ini" --silent < %SQL_FILE%
goto end

:noFile
echo %SQL_FILE% not found
exit /b 1

:end
