@echo off
setlocal EnableDelayedExpansion
set localOpts=!JAVA_OPTS:c:/localhost=c:/altlocalhost!
set DEPLOY_DIR=c:\altlocalhost
endlocal & set JAVA_OPTS=%localOpts% & set DEPLOY_DIR=%DEPLOY_DIR%
echo %java_opts%
