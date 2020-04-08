@echo off
rem arg 1: file filter
rem arg 2: dir sort options -- or -- text file containing the file names in the order to rename
rem arg 3: base filename
rem arg 4: start num

set fileFilter=%1
set dirOpts=%~2
set basename=%3
set counter=%4

if exist "%dirOpts%" call :renameFromFile "%dirOpts%"
goto end

rem else rename using diropts
for /f %%i in ('dir /b %dirOpts% %fileFilter%') do call :rename "%%i"
goto end

:renameFromFile
set fromFile=%~1
for /f %%i in (%fromFile%) do call :rename "%%i"
goto end

:rename
copy %1 %basename%_%counter%%~x1
set /a counter=counter+1


:end
