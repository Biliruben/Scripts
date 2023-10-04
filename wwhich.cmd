@echo off
setlocal
rem Expand on this list with other "executable" extensions
set EXECUTABLES=".exe,.cmd,.bat"
set TEST_NAME=%1
set FOUND=

rem Check just the name first
call :checkFound %TEST_NAME%

rem :checkFound defines 'FOUND'.  If set, we're done. If not, we got extra work
if NOT DEFINED FOUND (
	rem not found, try the known 'executable' extensions
	call :checkExecutables %EXECUTABLES%
)
rem Goto eof for the result
goto eof

:checkExecutables
set list=%1
rem removes surrounding "
set list=%list:"=%

rem recursive loop that pulls the first token and parses that,
rem the second token is sent back through the loop.
for /f "tokens=1* delims=," %%i in ("%list%") do (
	if not "%%i" == "" call :subCheck %%i
	if not "%%j" == "" call :checkExecutables "%%j"
)
goto :eof

:subCheck
rem Only check if FOUND is still undefined
if NOT DEFINED FOUND call :checkFound %TEST_NAME%%1
goto :eof

:checkFound
set FOUND=%~dp$PATH:1
goto :eof

:eof
if DEFINED FOUND echo %FOUND%
endlocal
