@echo off
setlocal
set LIB_DIR=c:\scripts\lib
set CLASSPATH=%CLASSPATH%;%LIB_DIR%
set CLASSPATH=%CLASSPATH%;%LIB_DIR%\jdom.jar
set CLASSPATH=%CLASSPATH%;%LIB_DIR%\resolver.jar
set CLASSPATH=%CLASSPATH%;%LIB_DIR%\serializer.jar
set CLASSPATH=%CLASSPATH%;%LIB_DIR%\xercesImpl.jar
set CLASSPATH=%CLASSPATH%;%LIB_DIR%\FilterXml_1.1.jar
set CLASSPATH=%CLASSPATH%;%LIB_DIR%\GetOpts_2.9.jar
set CLASSPATH=%CLASSPATH%;%LIB_DIR%\XmlApi_1.1.jar
set CLASSPATH=%CLASSPATH%;%LIB_DIR%\commons-logging-api-1.1.jar
call "%JAVA_HOME%\bin\java" -cp "%CLASSPATH%" %JAVA_OPTS% biliruben.tools.xml.FilterXml -remove id -xmlFile %*
endlocal
