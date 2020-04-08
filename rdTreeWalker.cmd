@echo off
@rem This script will take in a single argument, ala '.svn'.  It will then
@rem walk from the current working directory down to every node looking for
@rem that directory, where it will then remove said directory.
@rem
@rem set DEBUG to 'echo' for debug statements instead of action
set DEBUG= 

set DIRECTORY=%1
set TOO_MANY=%2
if not defined DIRECTORY goto badArg
if defined TOO_MANY goto badArg
call :processDir .
goto end


:processDir
set workingDir=%~1
if "%DEBUG%"=="echo" echo Processing %workingDir%
if exist "%workingDir%\%DIRECTORY%" call :deleteDir "%workingDir%\%DIRECTORY%"
@rem RECURSION!!!!
for /d %%i in (%workingDir%\*) do call :processDir "%%i"
goto end

:deleteDir
echo Deleting %1
%DEBUG% rd /s /q %1
goto end

:badArg
echo Exactly one argument must be passed!
exit /b 1

:end
rem TADA!
