@if defined doEcho (
    @echo %doEcho%
) else (
    @echo off
)
for /f %%i in ('call powershell '%JIRA_PREFIX%'.ToUpper^(^)') do set _u_JIRA_PREFIX=%%i

if %_u_JIRA_PREFIX%==EFIX set tagPrefix=x
if %_u_JIRA_PREFIX%==SET set tagPrefix=z
if %_u_JIRA_PREFIX%==IIQSR set tagPrefix=s
if %_u_JIRA_PREFIX%==IIQTC set tagPrefix=t
if %_u_JIRA_PREFIX%==IIQETN set tagPrefix=e
