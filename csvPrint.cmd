@echo off
set JARPATH=%~p0\lib
setlocal
set CLASSPATH=%CLASSPATH%;%JARPATH%\CSVSource_1.3.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\GetOpts_2.6.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\commons-logging-1.1.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\BilirubenUtil_0.1.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\WorkstationUtil_prov.jar
call %JAVA_HOME%\bin\java -cp "%CLASSPATH%" %JAVA_OPTS% biliruben.tools.CSVPrint %*
endlocal
