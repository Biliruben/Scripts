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

set JDK8=c:\jdk1.8.0_45
set JDK11=c:\jdk-11.0.11
set JDK14=c:\jdk-14.0.2
set JDK17=c:\jdk-17.0.6

set JDK_LIST=%JDK8% %JDK11% %JDK14% %JDK17%

call %SCRIPT_HOME%\makeChoice %JDK_LIST%
rem echo if not defined CHOICE choice /t 60 /D 1 /C %choiceStr% /M "Which JDK (%promptStr%)?"
if not defined choice choice /t 60 /d 1 /c %choicestr% /m "which jdk (%promptstr%)?"
if not defined choice set choice=%errorlevel%


REM labels
call :JDK_%CHOICE%
call :UPDATE_PATH %JAVA_HOME%
call %JAVA_HOME%\bin\java -version
endlocal & set path=%path%& set java_home=%java_home%
goto EOF

REM Generic path fixer upper
:UPDATE_PATH
set JDK_TOKEN=%1
for %%i in (%JDK_LIST%) do set PATH=!PATH:%%i=%JDK_TOKEN%!
goto EOF

REM JDK8
:JDK_1
set JAVA_HOME=%JDK8%
goto EOF

REM JDK11
:JDK_2
set JAVA_HOME=%JDK11%
goto EOF

REM JDK14
:JDK_3
set JAVA_HOME=%JDK14%
goto EOF

REM JDK17
:JDK_4
set JAVA_HOME=%JDK17%
goto EOF

:EOF
