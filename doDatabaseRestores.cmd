@call doEcho
setlocal
set DB_RECOVERY_DIR=c:\temp\databaseRecovery
for %%i in (%DB_RECOVERY_DIR%\databases*.txt) do call :startBackup %%i
goto eof

:startBackup
set dbFile=%1
echo Processing %dbFile%
start "%dbFile% Restore" /D %CD% restoreDbFile.cmd %dbFile%
goto eof

:eof


