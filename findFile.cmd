@echo off
setlocal
set JARPATH=%~p0\lib
set CLASSPATH=%CLASSPATH%;%JARPATH%\GetOpts_2.4.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\ThreadRunner_1.1.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\FileTools_0.1.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\BilirubenFiles_0.2.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\commons-logging-1.1.jar
call %JAVA_HOME%\bin\java -cp "%CLASSPATH%" %JAVA_OPTS% biliruben.tools.FindFile %*
endlocal
