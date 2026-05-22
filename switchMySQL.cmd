@if not defined doEcho set doEcho=off
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
REM Convience utility script to swap between various JDKS. When switching, will
REM change the JAVA_HOME variable to the desired JDK and update the PATH to
REM point to the java executable (and not point to any other java executable)

set MYSQL_BASE=c:\Program Files\MySQL
set MYSQL57=MySQL Server 5.7
set MYSQL80=MySQL Server 8.0
set MYSQL57_PATH=%MYSQL_BASE%\%MYSQL57%
set MYSQL80_PATH=%MYSQL_BASE%\%MYSQL80%
set MYSQL57_CHOICE=MySQL5.7
set MYSQL80_CHOICE=MySQL8.0

set MYSQL_LIST=%MYSQL57_CHOICE% %MYSQL80_CHOICE%
set MYSQL_PATH_LIST="%MYSQL57_PATH%" "%MYSQL80_PATH%"

call %SCRIPT_HOME%\makeChoice %MYSQL_LIST%
if not defined choice choice /t 60 /d 1 /c %choicestr% /m "which MySQL (%promptstr%)?"
if not defined choice set choice=%errorlevel%


REM labels
call :MYSQL_%CHOICE%
call :UPDATE_PATH "%MYSQL_PATH%"
endlocal & set path=%path% & set MYSQL_PORT=%MYSQL_PORT%
which mysql
echo.
goto EOF

REM Generic path fixer upper
:UPDATE_PATH
set PATH_TOKEN=%~1
for %%i in (%MYSQL_PATH_LIST%) do set PATH=!PATH:%%~i=%PATH_TOKEN%!
goto EOF

REM MYSQL5.7
:MYSQL_1
:MYSQL_57
:MYSQL_5.7
set MYSQL_PATH=%MYSQL57_PATH%
set MYSQL_PORT=3306
goto EOF

REM MYSQL80
:MYSQL_2
:MYSQL_8
:MYSQL_80
:MYSQL_8.0
set MYSQL_PATH=%MYSQL80_PATH%
set MYSQL_PORT=3307
goto EOF

:EOF

