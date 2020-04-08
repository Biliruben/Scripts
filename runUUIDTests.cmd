@echo off
set CLASSPATH=c:\scripts\lib\mysql-connector-java-5.1.13-bin.jar;c:\scripts\lib\UUIDTests.jar
java -cp %CLASSPATH% sailpoint.test.UUIDTests %1
