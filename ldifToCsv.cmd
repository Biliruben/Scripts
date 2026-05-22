@call %SCRIPT_HOME%\doEcho.cmd
setlocal
::call c:\scripts\setJDWPOpts.cmd
REM relies on Javax which isn't in JDK11.
rem set JAVA_HOME=c:\jdk1.8.0_45
set JARPATH=%~p0\lib
rem set CLASSPATH=%CLASSPATH%;.
:: Classes dir
:: This is a BUILD classpath!
set CLASSPATH=c:\gitroot\biliruben\bin
set CLASSPATH=%CLASSPATH%;%JARPATH%\commons-logging-1.1.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\log4j-1.2.16.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\CSVSource_1.9.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\jdom.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\resolver.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\serializer.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\XmlApi_1.4.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\xercesImpl.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\GetOpts_2.9.jar
::set CLASSPATH=%CLASSPATH%;%JARPATH%\TransformApp_0.3.jar
rem set CLASSPATH=%CLASSPATH%;%JARPATH%\TransformApp_0.2.2.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\slf4j-api-1.7.25.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\reflections-0.10.2.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\javassist.jar
set CLASSPATH=%CLASSPATH%;%JARPATH%\activation.jar
rem Set env for ldpaptive
call c:\DropBox\JavaAPI\ldaptive-2.4.1\bin\setEnv.cmd
call %JAVA_HOME%\bin\java -cp "%CLASSPATH%" %JAVA_OPTS% biliruben.tools.TransformApp -source directory -target csv %*
