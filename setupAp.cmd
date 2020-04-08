rem this isn't ready for prime time yet. AP needs a little help first:
rem - reads user.build.properties
rem - default target (and -clean, also) aren't private

@exit /B 1



@if not defined doEcho set doEcho=off
@echo %doEcho%
setlocal
set /p userPrefix=Prefix code [TC, SR, SET, efix]? 
if /I %userPrefix% EQU ap goto REC_ERR
if /I %userPrefix% EQU rapidss goto INV_ERR
rem setup base repo
set setupScript=setup%userPrefix%.cmd
set fullPath=%scriptsdir%\%setupScript%
if not exist %fullPath% goto FNF_ERR
call %fullPath% %*
rem call %scriptsdir%\setupJira.cmd %*

rem setup rapid-ss
call %scriptdir%\setupRapidss.cmd %*

endlocal
goto end

:REC_ERR
echo You cannot select 'AP'! You'll create a recursive loop, dumbass.
goto end

:FNF_ERR
echo %fullPath% is not a valid setup script, dummy.
goto end

:INV_ERR
echo Hey, stupid: You cannot select '%userPrefix%'; Only I get to use that.
goto end


:end
