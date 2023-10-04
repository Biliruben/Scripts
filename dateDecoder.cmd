@echo off
set JARPATH=%~p0\lib
setlocal
if not defined JAVA_HOME set JAVA_HOME=c:\jdk1.8.0_45
set CLASSPATH=%CLASSPATH%;%JARPATH%\DateDecoder.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\GetOpts_2.9.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\commons-logging-1.2.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\log4j-1.2.16.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\json.jar
call %JAVA_HOME%\bin\java %JAVA_OPTS% -cp %CLASSPATH% biliruben.tools.DateDecoder %*
endlocal
