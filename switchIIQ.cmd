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

set IIQ80="8.0 or lower"
set IIQ81=8.1-8.3
set IIQ84="8.4 or higher"

set IIQ_LIST=%IIQ80% %IIQ81% %IIQ84%

call %SCRIPT_HOME%\makeChoice %IIQ_LIST%
rem echo if not defined CHOICE choice /t 60 /D 1 /C %choiceStr% /M "Which JDK (%promptStr%)?"
if not defined choice choice /t 60 /d 1 /c %choicestr% /m "which IIQ (%promptstr%)?"
if not defined choice set choice=%errorlevel%

call :IIQ_%CHOICE%
endlocal & set path=%path%& set java_home=%java_home%& set CATALINA_HOME=%CATALINA_HOME%
goto EOF

:IIQ_1
:IIQ_7.0
:IIQ_7.1
:IIQ_8.0
rem 8.0 or lower
call switchjdk 1
call switchnode 1
call switchtomcat 1
goto eof

:IIQ_2
:IIQ_8.1
:IIQ_8.2
:IIQ_8.3
rem 8.1 through 8.3
call switchjdk 1
call switchnode 2
call switchtomcat 1
goto eof

:IIQ_3
:IIQ_develop
:IIQ_8.4
rem 8.4 or above
call switchjdk 2
call switchnode 2
call switchtomcat 2
goto eof

:EOF
