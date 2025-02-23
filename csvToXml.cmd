@echo off
setlocal
REM relies on Javax which isn't in JDK11.
REM TODO: Upgrayyyd
set JAVA_HOME=c:\jdk1.8.0_45
set JARPATH=%~p0\lib
rem set CLASSPATH=%CLASSPATH%;.
set CLASSPATH=%JARPATH%\commons-logging-1.1.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\log4j-1.2.16.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\CSVSource_1.4.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\jdom.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\resolver.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\serializer.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\XmlApi_1.4.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\xercesImpl.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\GetOpts_2.9.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\TransformApp_0.2.2.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\slf4j-api-1.7.25.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\reflections-0.10.2.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\javassist.jar
call %JAVA_HOME%\bin\java -cp "%CLASSPATH%" %JAVA_OPTS% biliruben.tools.TransformApp -source csv -target xml %*
