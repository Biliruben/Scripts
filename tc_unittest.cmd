@echo off
setlocal
set JAVA_OPTS=%JAVA_OPTS% -Dsailpoint.springConfig=unittest
call starttc
endlocal