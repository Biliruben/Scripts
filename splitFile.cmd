@echo off
setlocal
rem Splits the file by lines and at character limits if required
set JARPATH=%~p0\lib
set CLASSPATH=%CLASSPATH%;%JARPATH%\GetOpts_2.9.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\commons-logging-1.1.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\TextSplitter-0.2.jar
call java -cp "%CLASSPATH%" %JAVA_OPTS% biliruben.tools.TextSplitter %*
endlocal
