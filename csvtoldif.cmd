@echo off
setlocal
set JARPATH=%~p0\lib
if not defined JAVA_HOME set JAVA_HOME=c:\jdk1.8.0_45
set CLASSPATH=%JARPATH%\CSVSource_1.5.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\commons-logging-1.1.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\log4j-1.2.16.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\GetOpts_2.8.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\BilirubenUtil_0.1.jar
call %JAVA_HOME%\bin\java.exe -cp "%CLASSPATH%" %JAVA_OPTS% com.biliruben.tools.CSVToLDIF %*
