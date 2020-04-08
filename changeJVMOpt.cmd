@if [%doEcho%]==[] set doEcho=off
@echo %doEcho%
REM needs two ops: the JVM option and the value to set it to
REM Then update the JAVA_OPTS var to replace that value
REM
REM Use switchJDK as a guide to doing goofy things like this
REM Also, place to use that new fangled getOpts.cmd?

setlocal EnableDelayedExpansion

rem needs to be two otions
if [%4] EQU [] goto NotEnoughOptions
set options=%*

rem Oh, this took more time than the rest of the script will, but it's fun 
rem practice. Notes: doEcho/doLog are/might be used by getOpts, so that shit needs
rem to be taken into account (and doLog isn't currenlty). Also, this is all
rem dumping into the current session's env. Does it have to?
rem
rem No, I don't think so. switchJdk provides some inspiration
set getOptsCmd=call %SCRIPT_HOME%\getOpts.cmd "-name:none -value:none" %options%
call log getOptsCmd: %getOptsCmd%
set _yourEcho=%doEcho%
set doEcho=off

for /f "tokens=2" %%i in ('%getOptsCmd%') do set %%i
set doEcho=%_yourEcho%
@echo %doEcho%
set _yourEcho=

call log -name: %-name%
call log -value: %-value%

if %-name% EQU none goto NameNotProvided
if %-value% EQU none goto ValueNotProvided

REM G2G!
REM Next challenge: It's easy for me to switch known values of the JAVA_OPTS var
REM to a new value. But in this case, I shouldn't have to be told what the current
REM value of a given option is. I just need it to be a different value now. Ala,
REM given: -Xmx4096m
REM I'm not going to know about 4096m. It could just as well be: -XmxCummy.
REM But to do a string replacement, I have to tell it what the old value is...
REM
REM Or do I just have to strip the old token (-Xmx4096m / -XmxCummy) out and insert a 
REM new NVP on set? I bet that's easier to do...
REM Hmm, an astrick was used in one example.... I wonder
REM Nope, shit's dum. So were gonna call in 'for' to do another stupid thing
REM 'for' shouldn't have to do, because CMD

REM Iterate through the JAVA_OPTS var until you find a "token" that begins with %-name%.
REM Since options don't have inner-delimiters, tokens like -Xmx4096m and -XmxtremeMtnDew
REM will both be found when looking for 'startswith -Xmx'.... ohwell<shrug>

REm SIGH!!!! the Java_opts var, having lived through multiple generations of human life,
rem is an inconsistent beast, at best. Fuck it! It's easier to do this manually as needed 
rem than write this bullshit!

goto eof

:NotEnoughOptions
echo "Two name-value paired options must be passed: -name name -value value"
exit /b 1

:NameNotProvided
echo "-name paramter was not provided!"
exit /b 2

:ValueNotProvided
echo "-value parameter was not provided!"
exit /b 3

:eof
