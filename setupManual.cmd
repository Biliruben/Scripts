@if defined doEcho (
    @echo %doEcho%
) else (
    @echo off
)

setlocal
    echo JIRA_PREFIX:
    echo    E - ETN (iiqetn)
    echo    T - Twin Creeks (iiqtc)
    echo    S - Star Ranch (iiqsr)
    echo    Z - Set (set)
    echo    X - Efix (efix)
    choice /C ETSZX /T 15 /D E
    if errorlevel 5 (
        set JIRA_PREFIX=EFIX
    ) else if errorlevel 4 (
        set JIRA_PREFIX=SET
    ) else if errorlevel 3 (
        set JIRA_PREFIX=IIQSR
    ) else if errorlevel 2 (
        set JIRA_PREFIX=IIQTC
    ) else (
        rem Default IIQETN
        set JIRA_PREFIX=IIQETN
    )

set /p IIQ_TAG=IIQ_TAG $ 
set /p local_branch=Branch $ 
set noPause=true
call setupJira %*
