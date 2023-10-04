@echo off
setlocal
set JARPATH=%~p0\lib
set CLASSPATH=%CLASSPATH%;%JARPATH%\jdom.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\resolver.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\serializer.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\XmlApi_1.4.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\xercesImpl.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\GetOpts_2.1.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\TextPrinter.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\ROtoXML.0.1.jar
call %JAVA_HOME%\bin\java -cp "%CLASSPATH%" %JAVA_OPTS% sailpoint.tools.ResourceObjectToXMLAdapter -inputFile %1 -outputFile %2
endlocal

