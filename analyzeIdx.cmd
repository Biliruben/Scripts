@echo off
set JARPATH=%~p0\lib
set CLASSPATH=%CLASSPATH%;%JARPATH%\CSVSource_1.0a.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\IDXTools_1.0a.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\GetOpts_2.1.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\AnalyzeSQLCSVApp_1.1.jar
call %JAVA_HOME%\bin\java -cp "%CLASSPATH%" %JAVA_OPTS% sailpoint.services.tools.AnalyzeSQLCSVApp %*
