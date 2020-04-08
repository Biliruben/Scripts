@echo off
setlocal
for /r %%i in (*.rej) do call :clean %%i
endlocal
goto end

:clean
set FILE=%*
echo Cleaning: %FILE%
del /f /q "%FILE%"

:end
