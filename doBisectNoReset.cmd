@rem Set doEcho on to enable echo
@call setEcho.cmd
if [%1] NEQ [] (set BISECT_CMD=%1) else (set BISECT_CMD=log)
if not defined CATALINA_HOME set CATALINA_HOME=c:\tomcat-7.0.69
rem pushd %CATALINA_HOME%\bin
rem call shutdown.bat
rem popd
rem git bisect first
rem NO RESET!
rem git reset --hard
git bisect %BISECT_CMD%
if ERRORLEVEL 1 call :resetHard
if ERRORLEVEL 1 goto error
rem setup iiq; run tomcat
call %scriptsdir%\quickSetup.cmd
rem I may want to conditionalize this later...
rem call starttc.cmd
endlocal
goto eof

:resetHard
echo Resetting...
git reset --hard
git bisect %BISECT_CMD%
goto eof

:error
echo ERROR!
goto eof

:eof
