call %SCRIPT_HOME%\doEcho.cmd

:setlocal
pushd %GIT_HOME%
set archive=%GIT_HOME%\identityiq-%version%-src.zip
if exist "%archive%" (
    echo Deleting %archive%...
    del /q %archive%
)
echo Building new archive %archive%
rem Mac users (like Doug) struggle with jar
rem jar -cvfM %archive% .
call %SCRIPT_HOME%\7zip a %archive% .
popd
