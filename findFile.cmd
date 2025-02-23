@call %SCRIPT_HOME%\doEcho.cmd
rem @echo off
setlocal
set JARPATH=%~d0\%~p0\lib
set CLASSPATH=%CLASSPATH%;%JARPATH%\GetOpts_2.4.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\ThreadRunner_1.1.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\FileTools_0.1.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\BilirubenFiles_0.3.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\commons-logging-1.1.jar
call %JAVA_HOME%\bin\java -cp "%CLASSPATH%" %JAVA_OPTS% biliruben.tools.FindFile %*
endlocal

