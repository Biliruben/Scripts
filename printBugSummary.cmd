@echo off
setlocal
set SQL_FILE=c:/scripts/sql/showBugSummary.sql
set FULL_SQL_FILE=c:/scripts/sql/showBugDetail.sql
set BUG_ID=%1
set mysqlCmdStmt=mysql --defaults-file="c:\Program Files\MySQL\MySQL Server 5.5\bugz.ini" --silent -e
:parseCMDLineParams
shift
if [%1] EQU [--full] set FULL_SUMMARY=true
if [%1] NEQ [] goto parseCMDLineParams

call %mysqlCmdStmt% "set @bugId='%BUG_ID%'; source %SQL_FILE%;"

if defined FULL_SUMMARY call :printFullSummary

goto end

:printFullSummary
call %mysqlCmdStmt% "set @bugId='%BUG_ID%'; source %FULL_SQL_FILE%;" | java -jar c:\scripts\lib\TextPrinter.jar

:end
