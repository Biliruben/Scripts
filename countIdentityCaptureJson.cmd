@call %SCRIPT_HOME%\doEcho.cmd
setlocal
set FILE=%1
if [%FILE%] EQU [] goto noFile
if not exist %FILE% goto fileNotFound

set IMAGE_FIELDS=entitlements assignedRoles roleDetections accounts
set IMAGE_FIELDS_BASE=.eventImage.imageFields
for %%i in (%IMAGE_FIELDS%) do call :countImageField %%i
echo.
endlocal
goto eof

:noFile
echo No file provided
goto eof

:fileNotFound
%FILE% was not found!
goto eof

:countImageField
set iField=%1
echo.
echo %iField%:
call jq %IMAGE_FIELDS_BASE%.%iField% %FILE% | jq length
goto eof

:eof

