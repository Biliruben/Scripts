@echo off
set JARPATH=%~p0\lib
setlocal
set CLASSPATH=%CLASSPATH%;%JARPATH%\GetOpts_2.4.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\BetterThanSed.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\commons-logging-1.1.jar
call %JAVA_HOME%\bin\java -cp "%CLASSPATH%" biliruben.tools.BetterThanSed %*
endlocal
