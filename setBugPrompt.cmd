@echo off
setlocal enabledelayedexpansion
set BUG_NUMBER=%1
if [] EQU [%1] call :promptBug
if [] NEQ [%BUG_NUMBER%] (
    set NEW_PROMPT=$C$T$S$F$C$S%BUG_NUMBER%$S$F$S$P$G$_$$$S
) else (
    set NEW_PROMPT=$C$T$S$F$C$S$M$F$S$P$G$_$$$S
)
endlocal & set PROMPT=%NEW_PROMPT%
goto eof

:promptBug
set /p "BUG_NUMBER=Enter Bug Number: "

:eof
