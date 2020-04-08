@echo off
set JARPATH=%~p0\lib
setlocal
set JAVA_HOME=c:\jdk1.6.0_23
set CLASSPATH=%CLASSPATH%;%JARPATH%\DeepFileCopier_1.0.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\ThreadRunner_1.0a.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\GetOpts_2.4.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\commons-logging-1.1.jar
call %JAVA_HOME%\bin\java -cp "%CLASSPATH%" %JAVA_OPTS% biliruben.tools.DeepFileCopier %*
