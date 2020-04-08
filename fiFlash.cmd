@echo off
set JARPATH=%~p0\lib
setlocal
if not defined JAVA_HOME set JAVA_HOME=C:\jdk1.8.0_45
set CLASSPATH=%CLASSPATH%;%JARPATH%\BilirubenUtil_0.1.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\GetOpts_2.9.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\commons-logging-1.1.jar
set CLASSPATH=%CLASSPATH%;C:\DropBox\JavaAPI\log4j-1.2.16\log4j-1.2.16.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\FIFlashCards.jar
call %JAVA_HOME%\bin\java -cp "%CLASSPATH%" %JAVA_OPTS% biliruben.games.football.FIFlashCards -file c:\temp\FB-FI18.txt %*
endlocal
