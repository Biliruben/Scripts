@call %scriptsDir%\doEcho.cmd
setlocal

if not defined REST_HOST set REST_HOST=localhost
if not defined REST_PORT set REST_PORT=8080
if not defined REST_INST set REST_INST=iiq
if not defined REST_PROTO set REST_PROTO=http
call %SCRIPT_HOME%\dumpNames REST_HOST REST_PORT REST_INST
if not defined BASE_REST_URL set BASE_REST_URL=%REST_PROTO%://%REST_HOST%:%REST_PORT%/%REST_INST%

endlocal & set BASE_REST_URL=%BASE_REST_URL%
