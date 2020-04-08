@echo off
setlocal
set JARPATH=%~p0\lib
rem set CLASSPATH=%JARPATH%\NinjaWarBot_1.0.jar
set CLASSPATH=%JARPATH%\NinjaWarBot_2.0alpha.jar
set CLASSPATH=%CLASSPATH%;C:\DropBox\JavaAPI\Apache BeanUtils\commons-beanutils-1.8.3\commons-beanutils-1.8.3.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\ThreadRunner_1.1.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\CSVSource_1.2.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\BilirubenAPI_0.1.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\BilirubenFiles_0.1.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\GetOpts_2.4.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\commons-logging-1.1.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\jackson-all-1.9.9.jar
call %JAVA_HOME%\bin\java -cp "%CLASSPATH%" %JAVA_OPTS% biliruben.games.ninjawarz.NinjaBotApp -kongregate %*
endlocal
