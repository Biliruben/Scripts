@if [%doEcho%]==[] set doEcho=off
@echo %doEcho%

setlocal EnableDelayedExpansion

set _currentXmx=-Xmx4096m
set _newXmx=-Xmx%1m
rem needs to be two otions
if [%1] EQU [] goto NotEnoughOptions


REM G2G!
REM Next challenge: It's easy for me to switch known values of the JAVA_OPTS var
REM to a new value. But in this case, I shouldn't have to be told what the current
REM value of a given option is. I just need it to be a different value now. Ala,
REM given: -Xmx4096m
REM I'm not going to know about 4096m. It could just as well be: -XmxCummy.
REM But to do a string replacement, I have to tell it what the old value is...
REM
REM Fine. The old value is 4096m. FAOD
set _newOpts=!JAVA_OPTS:%_currentXmx%=%_newXmx%!
endlocal & set JAVA_OPTS=%_newOpts%
echo JAVA_OPTS=%JAVA_OPTS%
goto eof

:NotEnoughOptions
echo "Need to know the new -Xmx value"
exit /b 1

:eof
