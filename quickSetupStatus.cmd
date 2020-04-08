@call %SCRIPT_HOME%\setEcho.cmd
echo Quick Setup configuration values...
echo REPO_HOME=%REPO_HOME%
echo IIQ_TAG=%IIQ_TAG%
if defined IIQ_DEMO_DATA (
    echo IIQ_DEMO_DATA=%IIQ_DEMO_DATA%
) else (
    echo DEMO_DATA=%DEMO_DATA%
)
echo CATALINA_HOME=%CATALINA_HOME%
echo SCRIPT_HOME=%SCRIPT_HOME%
if defined IIQ_CMD echo IIQ_CMD=%IIQ_CMD%

