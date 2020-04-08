@echo off
setlocal
set JARPATH=%~p0\lib
set CLASSPATH=%CLASSPATH%;%JARPATH%\GetOpts_2.7.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\commons-logging-1.1.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\PruneDupes_1.0.jar
call %JAVA_HOME%\bin\java -cp "%CLASSPATH%" %JAVA_OPTS% sailpoint.file.PruneDupes %*
endlocal
