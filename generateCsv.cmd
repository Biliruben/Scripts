@echo off
set JARPATH=%~p0\lib
setlocal
if not defined JAVA_HOME set JAVA_HOME=C:\jdk1.6.0_29
set CLASSPATH=%JARPATH%\CSVSource_1.4.jar
rem set CLASSPATH=%CLASSPATH%;%JARPATH%\CSVGenerator_1.2.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\CSVGenerator_1.31.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\hibernate-3.5.2.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\commons-logging-1.1.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\log4j-1.2.16.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\GetOpts_2.8.jar
call %JAVA_HOME%\bin\java -cp "%CLASSPATH%" %JAVA_OPTS% biliruben.tools.CsvGenerator %*
endlocal

