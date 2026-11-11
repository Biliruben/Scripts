@call %SCRIPT_HOME%\doEcho.cmd
setlocal
@echo JDK ^& Node
@call java -version
@call node --version
@echo.
rem @echo CATALINA_HOME:
rem @echo %CATALINA_HOME%
call dumpNames JAVA_HOME CATALINA_HOME CATALINA_OPTS DEPLOY_DIR
if not defined DEPLOY_DIR set DEPLOY_DIR=c:\localhost
@echo.
@echo DEPLOY_DIR:
for %%i in (%DEPLOY_DIR%\*xml) do @echo %%i
endlocal
