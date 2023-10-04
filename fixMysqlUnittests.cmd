@echo off
setlocal
rem set CREATE_SQL=c:/scripts/sql/fixMysqlUsersForIIQ.sql
set CREATE_SQL=c:/scripts/sql/fixMysqlUnittestUsers.sql
set DATABASE_LIST=c:\temp\doThese.txt
set RECOVER_DIR=c:\scripts\sql\fixMysql
set mysqlCmdStmt=mysql -e

for /f %%i in (%DATABASE_LIST%) do call :fixUser %%i
goto eof

:fixUser
set iiqTag=%1
echo ------------------------------------------
echo Fixing %iiqTag%
echo ------------------------------------------
rem We already imported; Skip this step
rem set sqlFilename=%RECOVER_DIR%\%iiqTag%.sql
rem set sqlPluginFilename=%RECOVER_DIR%\%iiqTag%plugin.sql
rem call :importSql %sqlFilename%
rem call :importSql %sqlPluginFilename%
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
set fullStmt=%mysqlCmdStmt% "set @iiq_tag='%iiqTag%'; set @iiq_user='magellan'; set @iiq_password='magellan'; set @host_value='%hostValue%'; source %CREATE_SQL%;"
echo %fullStmt%
call %fullStmt%
goto eof

:eof
