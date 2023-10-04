rem @echo off
setlocal

set FACT_PATH=C:\Program Files\Factorio\bin\x64

rem set SAVE_FILE=%UserProfile%\AppData\Roaming\Factorio\saves\FreePlay - The Return - Infinity Gauntlet - Coruscant Prime.zip
set SAVE_FILE=%UserProfile%\AppData\Roaming\Factorio\saves\Free Play 8-ish - no crash.zip

rem Don't think this ini is used for anything, is it?
set CONFIG_FILE=%UserProfile%\Documents\Games\Factorio\server-local.ini

rem JSON CFG file
set JSON_CONFIG_FILE=%UserProfile%\Documents\Games\Factorio\server-settings.headless.json

rem if not defined FACT_OPTS set FACT_OPTS=--config "%CONFIG_FILE%" --server-settings %UserProfile%\.miscBits\server-settings-local.json --start-server "%SAVE_FILE%"
if not defined FACT_OPTS set FACT_OPTS=--server-settings %JSON_CONFIG_FILE% --start-server "%SAVE_FILE%"
call "%FACT_PATH%\factorio.exe" %FACT_OPTS%
endlocal
