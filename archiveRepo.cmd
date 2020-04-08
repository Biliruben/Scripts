@echo off
REM This script will find the last written to archive file and zip up the current Repositories2
REM directory to that archive.  To extend the number of archives, simply create additional files
REM in the destination directory.
setlocal
set SRC=C:\Users\trey.kirk\Google Drive\Repositories2
set DEST=C:\Users\trey.kirk\Google Drive\archive
set BASE_FILENAME=repositories2-

for /f "usebackq" %%i in (`dir /b /tw /od "%DEST%\%BASE_FILENAME%*"`) do call :findFirstFileName %DEST%\%%i
@echo Creating %DEST_FILENAME%
jar -cvfM "%DEST_FILENAME%" "%SRC%" > nul 2>&1
@echo Complete: %ERRORLEVEL%
endlocal
goto end


:findFirstFileName
if not defined DEST_FILENAME set DEST_FILENAME=%*
goto end



:end

