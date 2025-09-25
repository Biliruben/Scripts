setlocal
set FILE_BASE=%1
set DATABASE_BASE=%2
mysql -f %DATABASE_BASE% < %TEMP%\%FILE_BASE%.sql
mysql -f %DATABASE_BASE%ah < %TEMP%\%FILE_BASE%ah.sql
