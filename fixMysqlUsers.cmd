@echo off
setlocal
if not defined CREATE_USER_SQL set CREATE_USER_SQL=c:/scripts/sql/fixMysqlUsersForIIQ.sql
if not defined GRANT_PLUGIN_SQL set GRANT_PLUGIN_SQL=c:/scripts/sql/fixMysqlUsersForPlugin.sql
if not defined DATABASE_LIST set DATABASE_LIST=c:\scripts\allDatabases.txt
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
rem Fix User
set fullStmt=%mysqlCmdStmt% "set @iiq_user='%iiqTag%'; set @iiq_password='%iiqTag%'; set @host_value='%hostValue%'; source %CREATE_USER_SQL%;"
echo %fullStmt%
call %fullStmt%

rem Fix Plugin
set fullStmt=%mysqlCmdStmt% "set @iiq_user='%iiqTag%'; set @iiq_password='%iiqTag%'; set @host_value='%hostValue%'; source %GRANT_PLUGIN_SQL%;"
echo %fullStmt%
call %fullStmt%

set isAh=%iiqTag:iiq84=%
set isDev=%iiqTag:iiqdev=%
echo isAh:%isAh% isDev:%isDev%
rem If iiqTag has neither iiq84 or iiqdev in it, it does not require accesshistory lovin. We can test this by checking if
rem isAh and isDev are the same value since if either string matches, they would no longer have that string present
if %isAh% NEQ %isDev% (
    echo Fixing AccessHistory user for %iiqTag%
    set fullAhStmt=%mysqlCmdStmt% "set @iiq_user='%iiqTag%ah'; set @iiq_password='%iiqTag%ah'; set @host_value='%hostValue%'; source %CREATE_USER_SQL%;"
    echo %fullAhStmt%
    call %fullAhStmt%
)
goto eof

:eof
