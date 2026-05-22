@call doEcho
if [] EQU [%1] goto noFile
setlocal
call :getDBName %1
echo mysql %DB_NAME% ^< %1
mysql %DB_NAME% < %1
endlocal
goto eof

:getDBName
set testName=%~n1
if %testName:.=% EQU %testName% (
    set DB_NAME=%testName%
) else (
    call :getDBName %testName%
)
goto eof

:noFile
echo No file
goto eof

:eof
