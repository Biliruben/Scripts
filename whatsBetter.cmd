@echo off
setlocal
set limit=%1

for /l %%i in (1,1,%limit%) do call :doIt %%i
goto end

:doIt
set first=%1
set /a second=%limit%-%first%
set /a product=%first% * %second%
echo %first% x %second% = %product%
goto end

:end
