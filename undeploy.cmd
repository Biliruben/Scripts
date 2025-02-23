@echo off
setlocal
if not defined DEPLOY_DIR set DEPLOY_DIR=c:\localhost
:parseArgs
if [%1] EQU [] goto argsParsed
set undeployFile=%DEPLOY_DIR%\%1.xml
if not exist %undeployFile% goto NoDeploymentExists
if not exist %DEPLOY_DIR%\bu goto NoBackupDirectoryExists
move %undeployFile% %DEPLOY_DIR%\bu
shift
goto parseArgs

:argsParsed
dir %DEPLOY_DIR%
endlocal
goto end

:NoDeploymentExists
echo %undeployFile% does not exist
call :argsParsed
exit /b 1

:NoBackupDirectoryExists
echo %DEPLOY_DIR%\bu does not exist
call :argsParsed
exit /b 2

:end
