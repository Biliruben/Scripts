@echo off
set JARPATH=%~p0\lib
setlocal
if not defined JAVA_HOME set JAVA_HOME=C:\jdk1.6.0_29
set CLASSPATH=%CLASSPATH%;%JARPATH%\CSVSource_1.2.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\GetOpts_2.4.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\commons-logging-1.1.jar
REM set CLASSPATH=%CLASSPATH%;%JARPATH%\LogAnalyzer_2.96.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\LogAnalyzer_2.98.jar
set CLASSPATH=%CLASSPATH%;C:\DropBox\JavaAPI\log4j-1.2.16\log4j-1.2.16.jar
call %JAVA_HOME%\bin\java -cp "%CLASSPATH%" %JAVA_OPTS% sailpoint.services.tools.LogAnalyzerApp -properties c:\scripts\analyzeLog.properties %*
endlocal
