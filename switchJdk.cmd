@if not defined doEcho set doEcho=off
@echo %doEcho%
setlocal EnableDelayedExpansion

:: Clear CHOICE everytime
set CHOICE=
if [%1] EQU [] goto CmdLineDone
:: Else %1 is something...
:: If it's an integer, subtract 4
set /a CHOICE=%1-4 2>nul
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
set JDK8_BIN=%JDK8%\bin
set JDK8i586=c:\jdk1.8.0_45_i586
set JDK8i586_BIN=%JDK8i586%\bin
set JDK7=c:\jdk1.7.0_75
set JDK7_BIN=%JDK7%\bin
set JDK6=c:\jdk1.6.0_45
set JDK6_BIN=%JDK6%\bin
set JDK5=c:\jdk1.5.0_22
set JDK5_BIN=%JDK5%\bin

if not defined CHOICE choice /t 60 /D 8 /C 56789 /M "Which JDK?"
if not defined CHOICE SET CHOICE=%ERRORLEVEL%

REM Choice '5' returns as '1', '6' as '2', and '7' as '3'. Hence the oddly named
REM labels
call :JDK_%CHOICE%
call %JAVA_HOME%\bin\java -version
endlocal & set PATH=%PATH%& set JAVA_HOME=%JAVA_HOME%
goto EOF

REM JDK6
:JDK_1
set JAVA_HOME=%JDK5%
set PATH=!PATH:%JDK6%=%JDK5%!
set PATH=!PATH:%JDK7%=%JDK5%!
set PATH=!PATH:%JDK8%=%JDK5%!
goto EOF

REM JDK6
:JDK_2
set JAVA_HOME=%JDK6%
set PATH=!PATH:%JDK7%=%JDK6%!
set PATH=!PATH:%JDK5%=%JDK6%!
set PATH=!PATH:%JDK8%=%JDK6%!
goto EOF


REM JDK7
:JDK_3
:JDK_7.2
set JAVA_HOME=%JDK7%
set PATH=!PATH:%JDK5%=%JDK7%!
set PATH=!PATH:%JDK6%=%JDK7%!
set PATH=!PATH:%JDK8%=%JDK7%!
goto EOF


REM JDK8
:JDK_4
:JDK_develop
:JDK_7.3
set JAVA_HOME=%JDK8%
set PATH=!PATH:%JDK5%=%JDK8%!
set PATH=!PATH:%JDK7%=%JDK8%!
set PATH=!PATH:%JDK6%=%JDK8%!
goto EOF

REM JDK8i586
:JDK_5
set JAVA_HOME=%JDK8i586%
set PATH=!PATH:%JDK8%=%JDK8i586%!
set PATH=!PATH:%JDK7%=%JDK8i586%!
set PATH=!PATH:%JDK6%=%JDK8i586%!
set PATH=!PATH:%JDK5%=%JDK8i586%!
goto EOF



:EOF
