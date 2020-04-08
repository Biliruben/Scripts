@echo off
set JARPATH=%~p0\lib
setlocal
set CLASSPATH=%CLASSPATH%;%JARPATH%\CSVSource_1.2.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\GetOpts_2.6.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\commons-logging-1.1.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\WorkstationUtil_1.5.jar
call %JAVA_HOME%\bin\java -cp "%CLASSPATH%" %JAVA_OPTS% biliruben.sailpoint.WorkstationUtil filterDupe %*
endlocal
