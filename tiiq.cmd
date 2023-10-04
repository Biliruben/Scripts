setlocal
rem Using scripts\lib\console.jar in the classpath causes the iiq
rem script to go off the reservation with trying to find stuff
rem like L4j
rem set CLASSPATH=%CLASSPATH%;c:\scripts\TreyConsole_8.0_0.11.jar
set CLASSPATH=%CLASSPATH%;c:\GITRoot\sp-toolset\bin
rem set CLASSPATH=%CLASSPATH%;..\lib\aspectjrt-1.9.6.jar
rem set CLASSPATH=%CLASSPATH%;..\lib\aspectjrt-1.9.4.jar
rem set CLASSPATH=%CLASSPATH%;..\lib\commons-logging-1.2.jar
rem set CLASSPATH=%CLASSPATH%;..\lib\log4j-jcl-2.17.1.jar
rem set CLASSPATH=%CLASSPATH%;..\lib\log4j-api-2.17.1.jar
rem set CLASSPATH=%CLASSPATH%;..\lib\juniversalchardet-1.0.3.jar
rem set CLASSPATH=%CLASSPATH%;..\lib\hibernate-core-5.4.27.Final.jar
rem set CLASSPATH=%CLASSPATH%;..\lib\javax.persistence-api-2.2.jar
set CLASSPATH=%CLASSPATH%;..\lib\connector-bundle-identityiq.jar
set CLASSPATH=%CLASSPATH%;c:\scripts\lib\CSVSource_1.5.jar

@call iiq sailpoint.launcher.TreyConsole
endlocal
