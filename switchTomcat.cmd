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

set CAT7=c:\tomcat-7.0.69
set CAT9=c:\apache-tomcat-9.0.73

set CAT_LIST=%CAT7% %CAT9%

call %SCRIPT_HOME%\makeChoice %CAT_LIST%
rem echo if not defined CHOICE choice /t 60 /D 1 /C %choiceStr% /M "Which JDK (%promptStr%)?"
if not defined choice choice /t 60 /d 1 /c %choicestr% /m "which Tomcat (%promptstr%)?"
if not defined choice set choice=%errorlevel%


REM labels
call :CAT_%CHOICE%
rem call :UPDATE_PATH %CATALINA_HOME%
endlocal & set CATALINA_HOME=%CATALINA_HOME%
echo CATALINA_HOME=%CATALINA_HOME%
goto EOF

REM Generic path fixer upper
:UPDATE_PATH
set PATH_TOKEN=%1
for %%i in (%CAT_LIST%) do set PATH=!PATH:%%i=%PATH_TOKEN%!
goto EOF

REM CAT7
:CAT_1
set CATALINA_HOME=%CAT7%
goto EOF

REM CAT7
:CAT_2
set CATALINA_HOME=%CAT9%
goto EOF

:EOF
