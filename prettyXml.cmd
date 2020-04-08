@echo off

set JARPATH=%~d0%~p0lib
set CLASSPATH=%JARPATH%\XmlAPI_1.2.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\jdom.jar;%JARPATH%\resolver.jar;%JARPATH%\serializer.jar;%JARPATH%\xercesImpl.jar;%JARPATH%\XmlAPI_1.1.jar
%JAVA_HOME%\bin\java %JAVA_OPTS% -cp %CLASSPATH% com.biliruben.tools.xml.PrettyXML %*
