@echo off
setlocal
set JARPATH=%~p0\lib
set CLASSPATH=%CLASSPATH%;src\WEB-INF\classes;lib\commons-lang3\commons-lang3-3.12.0.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\CSVSource_1.4.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\GetOpts_2.9.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\commons-logging-1.1.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\LogAnalyzer_3.2a.jar
set CLASSPATH=%CLASSPATH%;C:\DropBox\JavaAPI\log4j-1.2.16\log4j-1.2.16.jar
set CLASSPATH=%CLASSPATH%;c:\GITRoot\sp-toolset\bin
if [%1] EQU [] goto usage
if [%1] EQU [comp] set execClass=sailpoint.tools.PropertiesComparator
if [%1] EQU [check] set execClass=sailpoint.tools.MessagePropertiesChecker
shift
goto exec

:usage
echo Usage: %0 comp^|check [parameters]
echo   comp: Compare two specific properties files
echo   check: Check all properties file types in a specified directory
goto eof

:exec
java -classpath %CLASSPATH% %execClass% %*

:eof
