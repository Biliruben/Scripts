@echo off
rem checkMessageProperties [Help|Message*]
rem
rem Executes in the pwd, looking in src\sailpoint\web\messages for Help or
rem Message properties files. * Default choice.
setlocal
set JARPATH=%~p0\lib
set CLASSPATH=%CLASSPATH%;%JARPATH%\WorkstationUtil_1.18.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\CSVSource_1.9.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\GetOpts_2.9.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\commons-logging-1.1.jar
call %JAVA_HOME%\bin\java -cp "%CLASSPATH%" %JAVA_OPTS% sailpoint.tools.PropertiesComparator %*
endlocal
