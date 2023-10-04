@call doEcho.cmd

set originalName=%1
set newName=%2

setlocal
call %SCRIPT_HOME%\SetScriptID.cmd
rem rename .xml and .command
ren %originalName%.xml %newName%.xml
ren %originalName%.command %newName%.command

for %%i in (*.*) do call :editFile %%i
dir
goto end


:editFile
set file=%1
set tmpFile=%file%_%ScrID%
copy /y %file% %tmpFile%
type %tmpFile% | sed s/%originalName%/%newName%/g > %file%
del /q %tmpFile%

:end
