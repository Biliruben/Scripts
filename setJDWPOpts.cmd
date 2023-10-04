@echo off
color 0c
set JAVA_OPTS=-Xdebug -Xrunjdwp:transport=dt_socket,address=5008,server=y %JAVA_OPTS%
set ANT_OPTS=-Xdebug -Xrunjdwp:transport=dt_socket,address=5008,server=y %ANT_OPTS% 
