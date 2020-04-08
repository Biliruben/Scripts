@echo off
set JARPATH=%~p0\lib
set CLASSPATH=%CLASSPATH%;%JARPATH%\CSVSource_1.0a.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\XmlApi_1.1.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\jdom.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\resolver.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\xercesImpl.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\GetOpts_2.0.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\SailPointXMLAnalyzer_1.0.jar
call %JAVA_HOME%\bin\java -cp "%CLASSPATH%" %JAVA_OPTS% sailpoint.xml.SailPointXMLAnalyzer %*
