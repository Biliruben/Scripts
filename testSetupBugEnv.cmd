@echo off
:setlocal
call %scriptsdir%\setupBugEnv 8.2 5544
env > c:\temp\bugEnv.txt
:endlocal
