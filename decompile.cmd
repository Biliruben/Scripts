@call %SCRIPT_HOME%\doEcho.cmd

setlocal
set JD_LIB=c:\DropBox\jd-gui\jd-gui-1.6.6.jar
start /B %JAVA_HOME%\bin\java -jar %JD_LIB% %*
