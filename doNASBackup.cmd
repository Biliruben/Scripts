@if defined doEcho (
    @echo %doEcho%
) else (
    @echo off
)

rem Initiates backing up of a selected list of directories to the NAS

setlocal
rem Set this variable to be a file that lists relative paths to skip
set EXCLUDE_FILE=
set SHARED_DRIVE=K:
set NAS_TGT_DIR=%SHARED_DRIVE%\sp_backup
set SRC_LIST_FILE=%SCRIPT_HOME%\NASBackup.src

call %SCRIPT_HOME%\connectBuffNas.cmd

call :setupBackupReport
call :reportTime
call :verifySource
if defined EXIT_CODE exit /b %EXIT_CODE%
rem call :mapNas
call %SCRIPT_HOME%\connectBuffNas.cmd
if defined EXIT_CODE exit /b %EXIT_CODE%
call :performBackup
if defined EXIT_CODE exit /b %EXIT_CODE%
call :unmapNas
if defined EXIT_CODE exit /b %EXIT_CODE%
call :reportTime
endlocal
goto eof

:reportTime
echo %date% %time%>>%BACKUP_REPORT%
goto eof

:setupBackupReport
call %SCRIPT_HOME%\setScriptId.cmd
set backupFileName=_backupReport_%scrId%.log
set BACKUP_REPORT=%SCRIPT_HOME%\log\%backupFileName%
if NOT EXIST %SCRIPT_HOME%\log (
    echo No log directory present undert %SCRIPT_HOME%!
    echo Using %SCRIPT_HOME% instead
    set BACKUP_REPORT=%SCRIPT_HOME%\%backupFileName%
)
echo Backup report file: %BACKUP_REPORT%
goto eof

:verifySource
if NOT EXIST %SRC_LIST_FILE% (
    echo %SRC_LIST_FILE% NOT FOUND!>>%BACKUP_REPORT%
    set EXIT_CODE=1
) else (
    echo Found %SRC_LIST_FILE%>>%BACKUP_REPORT%
)
goto eof

:mapNas
rem If there is a K: drive, unmap it
if exist %SHARED_DRIVE%\ (
    echo %SHARED_DRIVE% already mounted, unmounting.>>%BACKUP_REPORT%
    net use /delete %SHARED_DRIVE%>>%BACKUP_REPORT% 2>&1
    if exist %SHARED_DRIVE%\ (
        echo %SHARED_DRIVE% could not be unmounted!>>%BACKUP_REPORT%
        set EXIT_CODE=2
    )
)

if not exist %SHARED_DRIVE%\ (
    echo Mounting \\%NAS_HOST%\%NAS_SHARE% to %SHARED_DRIVE%>>%BACKUP_REPORT%
    net use %SHARED_DRIVE% \\%NAS_HOST%\%NAS_SHARE% /USER:%NAS_USER% %NAS_PASSWORD%>>%BACKUP_REPORT% 2>&1
)

if not exist %SHARED_DRIVE%\ (
    echo Could not map shared drive!>>%BACKUP_REPORT% 2>&1
    set EXIT_CODE=3
)
goto eof

:performBackup
rem First establish there's a target directory
if not exist %NAS_TGT_DIR% (
    echo %NAS_TGT_DIR% does not exist. Creating...>>%BACKUP_REPORT%
    mkdir %NAS_TGT_DIR%>>%BACKUP_REPORT% 2>&1
)
if not exist %NAS_TGT_DIR% (
    echo %NAS_TGT_DIR% could not be created!>>%BACKUP_REPORT%
    set EXIT_CODE=4
)
if exist %NAS_TGT_DIR% for /f %%i in (%SRC_LIST_FIlE%) do call :doBackupEntry "%%i"

goto eof

:doBackupEntry
rem Single parameter which is the full source path
set src=%~1
set tgt=%NAS_TGT_DIR%%~pn1
echo Backing up %src% to %tgt%>>%BACKUP_REPORT%
set excludeExpression= 
if defined EXCLUDE_FILE (
    if exist %EXCLUDE_FILE% set excludeExpression=/EXCLUDE:%EXCLUDE_FILE%
)
set xcopyExpr=xcopy /m /e /c /i /q /h /r /y /z %excludeExpression% %src% %tgt%
echo Executing: %xcopyExpr%>>%BACKUP_REPORT%
%xcopyExpr%>>%BACKUP_REPORT% 2>&1
goto eof

:unmapNas
if exist %SHARED_DRIVE% (
    echo Unmapping %SHARED_DRIVE%>>%BACKUP_REPORT%
    net use /delete %SHARED_DRIVE%>>%BACKUP_REPORT% 2>&1
)
if exist %SHARED_DRIVE% (
    echo Could not unmap %SHARED_DRIVE%>>%BACKUP_REPORT%
    set EXIT_CODE=5
)
goto eof

:eof
