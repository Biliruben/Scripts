@echo off
if NOT [%1] == [] (
mysql -B -e "select distinct(Db) from db" mysql | findstr /c:%1
) else (
mysql -B -e "select distinct(Db) from db" mysql
)
