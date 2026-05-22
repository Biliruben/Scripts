@call %SCRIPT_HOME%\doEcho.cmd
setlocal
set IIQ_TAG=%1
if not defined INIT_IMPORT_FILE set INIT_IMPORT_FILE=c:\scripts\initIIQ-import.iiq
if not defined INIT_EXEC_FILE set INIT_EXEC_FILE=c:\scripts\initIIQ-executeSetup.iiq
if not defined SCRIPT_HOME set SCRIPT_HOME=c:\scripts
if not defined IIQ_PROPS_BAK set IIQ_PROPS_BAK=iiq.properties.bak
if defined IIQ_TAG call :initIIQTag

rem choice /C NY /T 10 /D Y /M "Setup demo data?"
    echo Import and execute
    call iiq console < %INIT_IMPORT_FILE%
    call iiq console < %INIT_EXEC_FILE%
endlocal
goto end

:initIIQTag
    call iiq schema
    call %SCRIPT_HOME%\workstationutil.cmd convertDDL ..\..\ %IIQ_TAG%
    rem reset echo
    @call %SCRIPT_HOME%\doEcho.cmd
    if not exist ..\classes\%IIQ_PROPS_BAK% copy ..\classes\iiq.properties ..\classes\%IIQ_PROPS_BAK%
    if not defined INIT_SKIP_IIQ_PROP set INIT_SKIP_IIQ_PROP=false
    if %INIT_SKIP_IIQ_PROP% NEQ true call %SCRIPT_HOME%\workstationutil.cmd convertIIQProperties ..\classes %IIQ_TAG%
    mysql -e "drop database if exists %IIQ_TAG%"
    mysql -e "drop database if exists %IIQ_TAG%ah"
    mysql -e "drop database if exists %IIQ_TAG%plugin"
    echo Importing database DDL
    mysql < ..\database\create_identityiq_tables.mysql
goto end

:fuckshithell
echo FUCK SHIT HELL!
:end
