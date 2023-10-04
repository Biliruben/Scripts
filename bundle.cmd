call doEcho.cmd
setlocal
rem Given a list of directories, bundle them into a decompressed jar
set DIRECTORIES=*
if not defined NO_COMPRESS_FLAG set NO_COMPRESS_FLAG=0
if [%1] NEQ [] set DIRECTORIES=%*
echo Bundeling %DIRECTORIES%:
for /d %%i in (%DIRECTORIES%) do call :bundleDir %%i
endlocal
goto eof

:bundleDir
set dir=%~1
start "%dir%" /D "%dir%" jar -cvfM%NO_COMPRESS_FLAG% "..\%dir%.jar" .
goto eof

:eof
