@call doEcho.cmd
rem given a text file of terms and a search source file, find all lines 
rem not including any search terms
rem

if "%4" == "" goto usage

:setlocal
call SetScriptId
set _tempFile=%temp%\envScript_%ScrID%.cmd
call getOpts "-terms:terms.txt -search:search.txt" %* > %_tempFile%
call %_tempFile%
rem Begin building the cmd string
rem Reuse _tempFile 
echo type %-search% ^|^^>%_tempFile%
rem The default delim is a space, which is an invalid char for a property
for /f %%i in (%-terms%) do call :buildCmd %%i
rem because the last line ends in a pipe, we need one more command to make it
rem a valid multi-line statement
echo findstr /c:%_lastTerm% /v>>%_tempFile%
call %_tempFile%
del /q %_tempFile%

:endlocal
goto eof

:usage
echo Usage: filterOut -terms termFile -search searchFile
exit /b 1

:buildCmd
set _term=%1
call log _term: %_term%
echo findstr /c:%_term% /v ^|^^>>%_tempFile%
set _lastTerm=%_term%

:eof
