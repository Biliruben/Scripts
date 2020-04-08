@echo off
set targetFileName=%2
set targetSearchTerm=%1

for /f "delims=*" %%i in ('dir /b /s %2') do call :findInFile %%i
goto end

:findInFile
for /f "delims=~~~" %%j in ('findstr /c:"%targetSearchTerm%" "%1"') do call :sendResults "%%j" "%1"
goto end

:sendResults
for /f "delims=~~~" %%h in ('echo %2') do set fileName=%%~h
rem set fileName=%2
for /f "delims=~~~" %%h in ('echo %1') do set msg=%%~h
rem set msg=%1
echo %fileName% : %msg%
goto end

:end
