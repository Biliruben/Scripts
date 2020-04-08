@echo off
set JARPATH=%~p0\lib
set CLASSPATH=%JARPATH%\XMLTransform_1.1.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\GetOpts_2.8.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\XmlApi_1.4.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\commons-logging-1.1.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\jdom.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\resolver.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\xercesImpl.jar
java -classpath %CLASSPATH% sailpoint.xml.FindBreadCrumb %*
