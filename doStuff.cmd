copy /y c:\temp\alteredJDBCApp-UserPermissions.csv \GITRoot\iiq-ssh-2\build\WEB-INF\config\demo\data\JDBCApp-UserPermissions.csv
pushd build\web-inf\bin
call iiq.bat console < c:\scripts\doStuff.iiq
popd
