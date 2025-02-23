@call doEcho
setlocal
set etn_dir=%~1
set archiveFile=%etn_dir%.zip
pushd "%etn_dir%"
jar -cvfM "..\%archiveFile%" .
if not ERRORLEVEL 1 goto continueArchive
popd
echo "Failure compressing data."
exit /b %ERRORLEVEL%

:continueArchive
popd
rd /s /q "%etn_dir%"
mkdir "%etn_dir%"
move "%archiveFile%" "%etn_dir%"
