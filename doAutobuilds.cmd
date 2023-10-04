for /f "tokens=1,2" %%i in (c:\temp\branches.txt) do call :doAutobuild %%i %%j
goto eof

:doAutobuild
git checkout -f %1
call ant -Dbuild.tag=%2 clean,dist,autobuild-efix


:eof
