@call %SCRIPT_HOME%\doEcho.cmd
setlocal
@call java --version
@call node --version
@echo %CATALINA_HOME%
if not defined DEPLOY_DIR set DEPLOY_DIR=c:\localhost
dir %DEPLOY_DIR%\*xml
endlocal
