@echo off
rem takes a file and line number
rem If provided a third option, consider that to be an env var to populate the result in
set EXIT_CODE=0
if [%1] == [] (
    echo Must provide a file name!
    set EXIT_CODE=1
)
set FILE_NAME=%1
if [%2] == [] (
    echo Must provide a line number!
    set EXIT_CODE=2
)
set LINE_NUMBER=%2
set TARGET_VAR=%3
if %EXIT_CODE% GTR 0 exit /b %EXIT_CODE%
echo FILE_NAME = %FILE_NAME%
echo LINE_NUMBER = %LINE_NUMBER%
if defined TARGET_VAR echo TARGET_VAR = %TARGET_VAR%

set /a line=1
for /f "tokens=*" %%i in (%FILE_NAME%) do call :testLine "%%i"
goto end

:testLine 
if %line% EQU %LINE_NUMBER% call :foundLine "%~1"
set /a line=%line% + 1
goto end


:foundLine
rem we found our line, now spit it out or set it to the var
if defined TARGET_VAR (
    set %TARGET_VAR%=%~1
) else (
    echo %~1
)
goto end

:end
