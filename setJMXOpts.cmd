@echo off
echo This might not do what you want. Consider setJDWPOpts instead
rem sets JMX options in JAVA_OPTS
set JAVA_OPTS=-Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote=true -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.port=5006 %JAVA_OPTS% 
