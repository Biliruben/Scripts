@echo off
setlocal
set JARPATH=%~p0\lib
set CLASSPATH=%CLASSPATH%;%JARPATH%\UUIDDegenerator.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\GetOpts_2.1.jar
call %JAVA_HOME%\bin\java -cp "%CLASSPATH%" %JAVA_OPTS% biliruben.tools.UUIDDegenerator %*
endlocal
