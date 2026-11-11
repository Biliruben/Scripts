@call %SCRIPT_HOME%\doEcho.cmd
setlocal
set noCheck=false
if [%1] EQU [y] set noCheck=true
set CLEAN_OPTS=-d -e .* -e user.build.xml
if %noCheck% EQU false git clean --dry-run %CLEAN_OPTS%
if %noCheck% EQU false choice /C YN /M "Ready?" /T 300 /D N
if ERRORLEVEL 2 (
set ERROR_MSG=You said 'naw'
goto error
)

git clean -f %CLEAN_OPTS%

:error
endlocal
