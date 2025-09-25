setlocal
set DATABASE_BASE=%1
mysqldump --add-drop-table %DATABASE_BASE% > %TEMP%\%DATABASE_BASE%.sql
mysqldump --add-drop-table %DATABASE_BASE%ah > %TEMP%\%DATABASE_BASE%ah.sql
