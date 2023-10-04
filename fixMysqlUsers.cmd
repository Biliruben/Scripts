@echo off
setlocal
set CREATE_SQL=c:/scripts/sql/fixMysqlUsersForIIQ.sql
set DATABASE_LIST=c:\scripts\allDatabases.txt
rem set DATABASE_LIST=c:\temp\testUser.txt
set RECOVER_DIR=c:\scripts\sql\fixMysql
set mysqlCmdStmt=mysql -e

for /f %%i in (%DATABASE_LIST%) do call :fixUser %%i
goto eof

:fixUser
set iiqTag=%1
echo ------------------------------------------
echo Fixing %iiqTag%
echo ------------------------------------------
set sqlFilename=%RECOVER_DIR%\%iiqTag%.sql
set sqlPluginFilename=%RECOVER_DIR%\%iiqTag%plugin.sql
call :importSql %sqlFilename%
call :importSql %sqlPluginFilename%
set hostValue=localhost
call :doSql

set hostValue=%%%%
call :doSql

goto eof

:importSql
if exist %1 call mysql -f < %1
if not exist %1 echo %1 does not exist.
goto eof

:doSql
set fullStmt=%mysqlCmdStmt% "set @iiq_user='%iiqTag%'; set @iiq_password='%iiqTag%'; set @host_value='%hostValue%'; source %CREATE_SQL%;"
echo %fullStmt%
call %fullStmt%
goto eof

:eof
