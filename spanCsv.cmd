@echo off
set JARPATH=%~p0\lib
setlocal
set CLASSPATH=%CLASSPATH%;%JARPATH%\CSVSource_1.1.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\GetOpts_2.1.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\SpanCSV.jar
call %JAVA_HOME%\bin\java -cp "%CLASSPATH%" %JAVA_OPTS% com.biliruben.tools.SpanCSV %*
endlocal
