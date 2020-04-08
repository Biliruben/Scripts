@echo off
rem Valid command line parameters: convertDDL [build path] [db iiq tag]
rem   convertIIQProperties [git home path] [db iiq tag]
set JARPATH=%~p0\lib
setlocal
if not defined JAVA_HOME set JAVA_HOME=c:\jdk1.6.0_23
set CLASSPATH=%CLASSPATH%;%JARPATH%\WorkstationUtil_1.2.jar
call %JAVA_HOME%\bin\java -cp "%CLASSPATH%" %JAVA_OPTS% biliruben.sailpoint.WorkstationUtil %*
endlocal
