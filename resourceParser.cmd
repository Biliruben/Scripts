@echo off
setlocal
set JARPATH=%~p0\lib
set CLASSPATH=%CLASSPATH%;%JARPATH%\GetOpts_2.9.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\commons-logging-1.2.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\log4j-1.2.16.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\json.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\ResourceParser_0.1.jar
call %JAVA_HOME%\bin\java -cp "%CLASSPATH%" %JAVA_OPTS% sailpoint.tools.erin.ResourceParser %*
endlocal
