@if [%doEcho%]==[] set doEcho=off
@echo %doEcho%

setlocal EnableDelayedExpansion

:: Clear CHOICE everytime
set CHOICE=
if [%1] EQU [] goto CmdLineDone
:: Else %1 is something...
set /a CHOICE=%1 2>nul
:: If there was an error, it's NOT an integer. Set CHOICE to the literal value
if ERRORLEVEL 1 set CHOICE=%1
:: There may not have been an error and weird math was attempted... so one last
:: try
if %CHOICE% LEQ 0 set CHOICE=%1

:CmdLineDone

call %SCRIPT_HOME%\makeChoice 6.17.1 10.24.1
if not defined choice choice /t 60 /d 1 /c %choicestr% /m "which NodeJS (%promptstr%)?"
if not defined choice set choice=%errorlevel%

call :NVM_%CHOICE%
goto EOF

:NVM_1
rem 6.17.1
nvm use 6.17.1
goto EOF

:NVM_2
rem 10.24.1
nvm use 10.24.1
goto EOF

:EOF
