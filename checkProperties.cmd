@echo off
setlocal
set CLASSPATH=%CLASSPATH%;src\WEB-INF\classes;lib\commons-lang3\commons-lang3-3.12.0.jar
set CLASSPATH=%CLASSPATH%;c:\GITRoot\sp-toolset\bin

java -classpath %CLASSPATH% sailpoint.tools.MessagePropertiesChecker %1
