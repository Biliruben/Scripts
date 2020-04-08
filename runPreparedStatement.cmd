@echo off
@setLocal
set SQL_FILE=%scriptsdir%\sql\showBugSummary.sql
set BUG_ID=%1
call mysql --defaults-file="c:\Program Files\MySQL\MySQL Server 5.5\bugz.ini" --silent -e "set @bugId=%BUG_ID%; .\ %SQL_FILE%"
