@set doEcho=off
@echo %doEcho%
setlocal
set JIRA_PREFIX=IIQMAG
call %scriptsdir%\resumeJira.cmd %*
endlocal & set PATH=%PATH%& set JAVA_HOME=%JAVA_HOME%
