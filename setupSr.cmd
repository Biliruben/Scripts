@if defined doEcho (
    @echo %doEcho%
) else (
    @echo off
)
setlocal
set JIRA_PREFIX=IIQSR
call %scriptsdir%\setupJira.cmd %*
endlocal & set PATH=%PATH%& set JAVA_HOME=%JAVA_HOME%
