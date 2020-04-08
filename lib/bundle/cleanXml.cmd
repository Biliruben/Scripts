@echo off
set LIB_DIR=c:\scripts\lib
set CLASSPATH=%CLASSPATH%;%LIB_DIR%
set CLASSPATH=%CLASSPATH%;%LIB_DIR%\jdom.jar
set CLASSPATH=%CLASSPATH%;%LIB_DIR%\resolver.jar
set CLASSPATH=%CLASSPATH%;%LIB_DIR%\serializer.jar
set CLASSPATH=%CLASSPATH%;%LIB_DIR%\xercesImpl.jar
set CLASSPATH=%CLASSPATH%;%LIB_DIR%\FilterXml_1.0.jar
set CLASSPATH=%CLASSPATH%;%LIB_DIR%\GetOpts_1.0a.jar
set CLASSPATH=%CLASSPATH%;%LIB_DIR%\XmlApi_1.1.jar
call "%JAVA_HOME%\bin\java" -cp "%CLASSPATH%" %JAVA_OPTS% sailpoint.xml.FilterXml -remove id -xmlFile %*
