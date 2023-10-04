@echo off
setlocal
for /f %%i in (c:\temp\versions.txt) do call :doIt %%i
endlocal
goto eof

:doIt
set TOKEN=%1
echo Testing %TOKEN%
pushd c:\test_installs\%TOKEN%\WEB-INF\bin
call iiq console < c:\temp\doL4jTest.iiq
popd

:eof
