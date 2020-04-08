@echo off
call :showCD "%CD%"
goto end

:showCD
@echo %~f1

:end
