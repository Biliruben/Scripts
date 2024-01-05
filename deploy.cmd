@echo off
setlocal
if not defined DEPLOY_DIR set DEPLOY_DIR=c:\localhost
:parseArgs
if [%1] EQU [] goto argsParsed
set deployFile=%DEPLOY_DIR%\bu\%1.xml
if not exist %deployFile% goto NoDeploymentExists
move %deployFile% %DEPLOY_DIR%
shift
goto parseArgs
:argsParsed
dir %DEPLOY_DIR%
endlocal
goto end

:NoDeploymentExists
echo %deployFile% does not exist
dir %DEPLOY_DIR%
exit /b 1

:end
