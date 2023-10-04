@echo off
setlocal
set FILENAME=c:\gitroot\iiq-ssh-2\efix\identityiq-8.1-8.1p3-IIQCB-4601.zip
for /f %%i in (c:\temp\versions.txt) do call :doIt %%i
endlocal
goto eof

:doIt
set filePath=c:\test_installs\%1
echo Deploying %filePath%
pushd %filePath%
jar -xvf %FILENAME%
popd

:eof
