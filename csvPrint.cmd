@echo off
set JARPATH=%~p0\lib
setlocal
rem set CLASSPATH=%CLASSPATH%;%JARPATH%\CSVSource_1.4.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\CSVSource_1.5.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\CSVPrint_0.2.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\GetOpts_2.9.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\commons-logging-1.1.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\BilirubenUtil_0.1.jar
call %JAVA_HOME%\bin\java -cp "%CLASSPATH%" %JAVA_OPTS% biliruben.tools.CSVPrint %*
endlocal
