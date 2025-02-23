@call doEcho
setlocal
set DB_RECOVERY_DIR=c:\temp\databaseRecovery
for %%i in (%DB_RECOVERY_DIR%\databases*.txt) do call :startBackup %%i
goto eof

:startBackup
set dbFile=%1
echo Processing %dbFile%
start "%dbFile% Backup" /D %CD% backupDbFile.cmd %dbFile%
goto eof

:eof

