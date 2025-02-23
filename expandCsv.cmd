@call doEcho
setlocal
set JARPATH=%~p0\lib
set CLASSPATH=%CLASSPATH%;%JARPATH%\CSVSource_1.8.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\GetOpts_2.9.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\commons-logging-1.1.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\BilirubenUtil_0.1.jar
call %JAVA_HOME%\bin\java -cp "%CLASSPATH%" %JAVA_OPTS% com.biliruben.util.csv.CSVJoiner %*
endlocal

