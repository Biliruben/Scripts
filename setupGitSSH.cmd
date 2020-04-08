@if defined doEcho (
    @echo %doEcho%
) else (
    @echo off
)
set FORCE=%1
if DEFINED SSH_AUTH_SOCK goto alreadySet
goto doIt
goto end

:doIt
set SSH_BIN=C:\Program Files\Git\usr\bin
if DEFINED FORCE echo Resetting GIT SSH environment
rem call setScriptId.cmd
set SSH-AGENT-TEMPFILE=%TEMP%\_ssh-agent.%RANDOM%
call "%SSH_BIN%\ssh-agent" -c > %SSH-AGENT-TEMPFILE%
for /f "delims=~" %%i in (%SSH-AGENT-TEMPFILE%) do call %%i

REM Change this to point to your private key
call "%SSH_BIN%\ssh-add" %HOMEPATH%\.ssh\id_rsa
if /i [%doEcho%] EQU [on] type %SSH-AGENT-TEMPFILE%
REM Rem out following to preserve temporary file
del /q %SSH-AGENT-TEMPFILE%
goto end

:alreadySet
rem echo GIT SSH environment already set
rem Don't echo anything
rem It doesn't matter what 'FORCE' is set to. it being set is enough
if DEFINED FORCE goto doIt
goto end

:end
