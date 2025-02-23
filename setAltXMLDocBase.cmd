@echo off
setlocal EnableDelayedExpansion
set localOpts=!JAVA_OPTS:c:/localhost=c:/altlocalhost!
endlocal & set JAVA_OPTS=%localOpts%
echo %java_opts%
