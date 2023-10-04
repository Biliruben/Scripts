rem @echo off
setlocal
set FACT_PATH=C:\Program Files\Factorio\bin\x64
set CONFIG_FILE=%UserProfile%\.miscBits\server-local.ini
if not defined FACT_OPTS set FACT_OPTS=--config "%CONFIG_FILE%" --server-settings %UserProfile%\.miscBits\server-settings-local.json
call "%FACT_PATH%\factorio.exe" %FACT_OPTS%
endlocal
