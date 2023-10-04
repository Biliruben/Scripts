call doEcho.cmd
setlocal
rem Given a list of bundled jar files, create a new directory of their
rem name and unjar the contents into that directory
set ERROR_MSG=None
if [%1] EQU [] set ERROR_MSG=No bundled jar files specified.
set FILES=%*
if %ERROR_MSG% NEQ None goto error
for %%i in (%FILES%) do call :unbundleJar %%i
endlocal
goto eof

:unbundleJar
set file=%~1
set dir=%~n1
if exist "%dir%" (
  set ERROR_MSG=%dir% already exists!
  goto error
)
mkdir "%dir%"
start "%dir%" /D "%dir%" jar -xvf "..\%file%"
goto eof


:error
echo %ERROR_MSG%
endlocal
exit /B 1

:eof
