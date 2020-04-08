@echo off
for %%i in (*.*) do call :openAll "%%i"
goto end

:openAll
start "Hidden CMD" %1

:end
