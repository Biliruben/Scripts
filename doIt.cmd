@echo off
for /l %%i in (1,1,15) do call :makeVote
goto eof

:makeVote
call %scriptsdir%\doPoll.cmd
rem set /A SLEEPER=%RANDOM%/2000
set SLEEPER=30
echo sleeping for %SLEEPER%...
sleep %SLEEPER%

:eof
