@if defined doEcho (
    @echo %doEcho%
) else (
    @echo off
)

setlocal
set NAS_USER=admin
set NAS_PASSWORD=fuckCovid2020too!
set NAS_HOST=buffy
set NAS_SHARE=Trey-FTP
set EXIT_CODE=0

if not defined BACKUP_REPORT set BACKUP_REPORT=%temp%\connectBuffNas_rpt.txt
if not defined SHARED_DRIVE set SHARED_DRIVE=K:

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

exit /b %EXIT_CODE%
