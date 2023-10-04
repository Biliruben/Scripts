@echo off
set JAVA_OPTS=-Dhttp.proxyHost=127.0.0.1 -Dhttp.proxyPort=8888 -Dhttp.nonProxyHosts="localhost" %JAVA_OPTS%
