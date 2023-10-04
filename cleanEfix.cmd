@echo off
setlocal
if [%1] EQU [] goto noArg
set efixManifest=%1
if NOT EXIST WEB-INF goto wrongDir
if NOT EXIST %efixManifest% goto noFile
for /f %%i in (%efixManifest%) do call :pruneFile %%i
del /f %efixManifest%
goto eof

:pruneFile
set fileNameRaw=%1
set fileName=%fileNameRaw:/=\%
echo Pruning %fileName%
del /f "%fileName%"
goto eof

:noArg
echo Efix filename is required
exit /b 1

:wrongDir
echo Must be executed in base IIQ installation directory
exit /b 2

:noFile
echo %efixManifest% was not found
exit /b 3

:eof
