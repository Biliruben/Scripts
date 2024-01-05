rem @echo off
setlocal
set IIQ_TAG=%1
if not defined INIT_IMPORT_FILE set INIT_IMPORT_FILE=c:\scripts\initIIQ-import.iiq
if not defined INIT_EXEC_FILE set INIT_EXEC_FILE=c:\scripts\initIIQ-executeSetup.iiq
if not defined SCRIPT_HOME set SCRIPT_HOME=c:\scripts
if defined IIQ_TAG (
    call iiq schema
    call %SCRIPT_HOME%\workstationutil.cmd convertDDL ..\..\ %IIQ_TAG%
    mysql -e "drop database if exists %IIQ_TAG%"
    mysql -e "drop database if exists %IIQ_TAG%ah"
    mysql -e "drop database if exists %IIQ_TAG%plugin"
    echo Importing database DDL
    mysql < ..\database\create_identityiq_tables.mysql
)
rem choice /C NY /T 10 /D Y /M "Setup demo data?"
    echo Import and execute
    call iiq console < %INIT_IMPORT_FILE%
    call iiq console < %INIT_EXEC_FILE%
goto end
endlocal
:fuckshithell
echo FUCK SHIT HELL!
:end
