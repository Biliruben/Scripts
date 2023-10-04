@rem Adds ui/jspm.config.js to the efix.filelist, rebuilds, and re-bundles
for /f "eol=# tokens=1,2" %%i in (c:\etn_data\ETN-99~2\branches.txt) do call :doAutobuild %%i %%j
goto eof

:doAutobuild
git checkout -f %1
if ERRORLEVEL 1 exit /b
echo ui/jspm.config.js>> efix.filelist
copy /y "c:\etn_data\ETN-9997 - Efixing aint easy but at least its not fun\identityiq-IIQPB-1008-README.txt" web\WEB-INF\efixes
git commit -i web\WEB-INF\efixes\identityiq-IIQPB-1008-README.txt -i efix.filelist -m "IIQETN-9997 - %2 - Add jspm.config.js to efix"
call ant -Dbuild.tag=GA_%2 clean,dist,bundle-efix

:eof
