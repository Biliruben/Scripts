@echo off
echo.
dir /b *zip
echo.
choice /M "Gonna unzip all those zips and make directories. Lez go?"
if ERRORLEVEL 2 goto naw
for %%i in (*.zip) do (
echo Making %%~ni
mkdir "%%~ni"
pushd "%%~ni"
echo Unzipping %%i
jar -xvf "..\%%i"
popd
)
goto eof

:naw
Echo ...naw
exit /b 1

:eof
