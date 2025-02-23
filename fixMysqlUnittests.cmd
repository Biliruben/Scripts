@echo off
setlocal
rem set CREATE_SQL=c:/scripts/sql/fixMysqlUsersForIIQ.sql
if not defined CREATE_SQL set CREATE_SQL=c:/scripts/sql/fixMysqlUnittestUsers.sql
if not defined DATABASE_LIST set DATABASE_LIST=c:\temp\doThese.txt
set mysqlCmdStmt=mysql -e

for /f %%i in (%DATABASE_LIST%) do call :fixUser %%i
goto eof

:fixUser
set iiqTag=%1
echo ------------------------------------------
echo Fixing %iiqTag%
echo ------------------------------------------
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
rem Fix Unittest
set fullStmt=%mysqlCmdStmt% "set @iiq_tag='%iiqTag%'; set @iiq_user='magellan'; set @iiq_password='magellan'; set @host_value='%hostValue%'; source %CREATE_SQL%;"
echo %fullStmt%
call %fullStmt%

goto eof

:eof
