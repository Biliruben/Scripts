@if not defined doEcho set doEcho=off
@echo %doEcho%
rem Valid command line parameters: convertDDL [build path] [db iiq tag]
rem   convertIIQProperties [git home path] [db iiq tag]
set JARPATH=%~p0\lib
setlocal
if not defined JAVA_HOME set JAVA_HOME=c:\jdk1.6.0_23
set CLASSPATH=%CLASSPATH%;%JARPATH%\WorkstationUtil_1.17.jar
rem set CLASSPATH=%CLASSPATH%;%JARPATH%\WorkstationUtil_1.14.jar
call %JAVA_HOME%\bin\java -cp "%CLASSPATH%" -Xrunjdwp:transport=dt_socket,address=5008,server=y %JAVA_OPTS% biliruben.sailpoint.WorkstationUtil %*
endlocal
