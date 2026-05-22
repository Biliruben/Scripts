call %SCRIPT_HOME%\doEcho.cmd
setlocal enabledelayedexpansion
:loop
set var=%1
if [%var%] EQU [] goto end
echo %var%=!%var%!
shift
goto loop
:end
