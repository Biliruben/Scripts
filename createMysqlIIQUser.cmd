@setlocal
@set username_base=%1
@call :createUser
@call :createUser plugin
@call :createUser ah
@endlocal
@goto eof

:createUser
@set objName=%username_base%%1
@if [%1] EQU [] set objName=%username_base%
mysql -e "create user if not exists '%objName%'@'%%' identified with mysql_native_password by '%objName%';"
mysql -e "create user if not exists '%objName%'@'localhost' identified with mysql_native_password by '%objName%';"
mysql -e "grant all privileges on %objName%.* to '%objName%'@'%%';"
mysql -e "grant all privileges on %objName%.* to '%objName%'@'localhost';"

@goto eof

:eof
