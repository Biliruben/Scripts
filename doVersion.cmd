@rem Adds sailpoint/Version.class and sailpoint/VersionConstants.class to the efix.filelist
for /f "eol=# tokens=1,2" %%i in (c:\etn_data\ETN-99~2\branches.txt) do call :doAutobuild %%i %%j
goto eof

:doAutobuild
git checkout -f %1
if ERRORLEVEL 1 exit /b
echo WEB-INF/classes/sailpoint/Version.class>> efix.filelist
echo WEB-INF/classes/sailpoint/VersionConstants.class>> efix.filelist
git commit -i efix.filelist -m "IIQETN-9997 - %2 - Add VersionConstants to efix"
call ant -Dbuild.tag=GA_%2 clean,dist,bundle-efix

:eof
