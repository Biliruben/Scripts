@echo off
set FORCE=%1
if DEFINED SSH_AUTH_SOCK goto alreadySet
goto doIt
goto end

:doIt
if DEFINED FORCE echo Resetting GIT SSH environment
rem call setScriptId.cmd
set SSH-AGENT-TEMPFILE=%TEMP%\_ssh-agent.%RANDOM%
call ssh-agent -c > %SSH-AGENT-TEMPFILE%
for /f "delims=~" %%i in (%SSH-AGENT-TEMPFILE%) do call %%i

REM Change this to point to your private key
ssh-add %HOMEPATH%\.ssh\id_rsa
del /q %SSH-AGENT-TEMPFILE%
goto end

:alreadySet
rem echo GIT SSH environment already set
rem Don't echo anything
rem It doesn't matter what 'FORCE' is set to. it being set is enough
if DEFINED FORCE goto doIt
goto end

:end
