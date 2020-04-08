@echo off
setlocal DisableDelayedExpansion
if "%1" == "" set ERROR_CODE=You must provide a file mask!
if "%2" == "" set ERROR_CODE=You must provide a target file!
if defined ERROR_CODE goto failure
set FILE_MASK=%1
set FinalScript=%2

setlocal EnableDelayedExpansion
for /F "tokens=*" %%a in ('chcp') do for %%b in (%%a) do set "CP=%%~nb"
if  !CP! NEQ 437 if !CP! NEQ 65001 chcp 437 >nul && (

    REM for file operations, the script must restatred in a new instance.
    "%COMSPEC%" /c "%~f0"

    REM Restoring previous code page
    chcp !CP! >nul
    exit /b
)
endlocal


set "RemoveUTF8BOM=(pause & pause & pause)>nul"
set "echoNL=echo("

:: If you want the final script to start with UTF-8 BOM (This is optional)
:: Create an empty file in NotePad and save it as UTF8-BOM.txt with UTF-8 encoding.
:: Or Create a file in your HexEditor with this byte sequence: EF BB BF
:: and save it as UTF8-BOM.txt
:: The file must be exactly 3 bytes with the above sequence.
(
    rem Nope, I wanna REMOVE the BOM!
    rem type "UTF8-BOM.txt" 2>nul

    REM This assumes that all sql files start with UTF-8 BOM
    REM If not, then they will loose their first 3 otherwise legitimate characters.
    REM Resulting in a final corrupted script.
    for %%A in (%FILE_MASK%) do (type "%%~A" & %echoNL%)|(%RemoveUTF8BOM% & findstr "^")

)>"%FinalScript%"

goto eof

:failure
echo %ERROR_CODE%
exit /b 1

:eof
