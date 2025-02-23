@echo off
setlocal
set JARPATH=%~p0\lib
set CLASSPATH=%JARPATH%\jdom.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\resolver.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\serializer.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\xercesImpl.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\XmlApi_1.2.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\CSVSource_1.0a.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\XMLTransform_1.1.jar
rem set CLASSPATH=%CLASSPATH%;%JARPATH%\XMLTransform_1.2.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\GetOpts_2.0.jar
call %JAVA_HOME%\bin\java -cp "%CLASSPATH%" %JAVA_OPTS% sailpoint.xml.XMLAnalyzerApp %*
endlocal
