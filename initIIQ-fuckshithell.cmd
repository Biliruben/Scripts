rem @echo off
setlocal
set IIQ_TAG=%1
if not defined SCRIPT_HOME set SCRIPT_HOME=c:\scripts
if defined IIQ_TAG (
    call iiq schema
    call %SCRIPT_HOME%\workstationutil.cmd convertDDL ..\..\ %IIQ_TAG%
    mysql -e "drop database if exists %IIQ_TAG%"
    echo Importing database DDL
    mysql < ..\database\create_identityiq_tables.mysql
)
rem choice /C NY /T 10 /D Y /M "Setup demo data?"
set ERRORLEVEL=2
if ERRORLEVEL 255 goto fuckshithell
if ERRORLEVEL 2 (
    echo Import and execute
    call iiq console < c:\scripts\initIIQ-import.iiq
    call iiq console < c:\scripts\initIIQ-executeSetup.iiq
) else (
    echo ...else
    if not defined IIQ_TAG (
        rem ERRORLEVEL could be 0, which is "do nothing"
        rem Actually, just don't import anything. 9 out of 10 times
        rem I just want to rehydrate an existing environment
        rem if ERRORLEVEL 1 call iiq console < c:\scripts\initIIQ-import-core.iiq
        echo Rehydrating only. Call iiq console ^< c:\scripts\initIIQ-import.iiq for importing objects.
    ) else (
        echo Import only
        call iiq console < c:\scripts\initIIQ-import.iiq
    )
)
goto end
endlocal
:fuckshithell
echo FUCK SHIT HELL!
:end
