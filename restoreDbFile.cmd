@call doEcho
setlocal
set localDbFile=%1
echo %localDbFile%
echo Recovery dir: %DB_RECOVERY_DIR%
for /f %%i in (%localDbFile%) do (
    echo %%i
    mysql -f < %%i.sql
)
