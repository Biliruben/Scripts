@echo off
set JARPATH=c:\scripts\lib
setlocal
if not defined JAVA_HOME set JAVA_HOME=C:\jdk1.6.0_29
set CLASSPATH=%JARPATH%\WorkstationUtil_1.5.jar
call %JAVA_HOME%\bin\java -cp "%CLASSPATH%" %JAVA_OPTS% biliruben.sailpoint.WorkstationUtil createHierarchy %*
endlocal

