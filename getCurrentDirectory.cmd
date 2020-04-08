@echo %doEcho%
rem While %CD% contains the full path of the current directory, sometimes
rem it's desired to get just the current directory's name, and not
rem the full path. This here sets BASE_CD of just that
rem
for /D %%i in (%CD%) do set BASE_CD=%%~ni
rem echo %BASE_CD%
