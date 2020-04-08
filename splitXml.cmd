@echo off
setlocal
set JARPATH=%~p0\lib
set CLASSPATH=%CLASSPATH%;%JARPATH%\jdom.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\resolver.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\serializer.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\XmlApi_1.3.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\xercesImpl.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\GetOpts_2.1.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\ThreadRunner_1.0a.jar
call %JAVA_HOME%\bin\java -cp "%CLASSPATH%" %JAVA_OPTS% com.biliruben.tools.xml.SplitXml %*
endlocal
