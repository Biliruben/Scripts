@rem Set doEcho on to enable echo
@call setEcho.cmd
if [%1] NEQ [] (set BISECT_CMD=%1) else (set BISECT_CMD=log)
if not defined CATALINA_HOME set CATALINA_HOME=c:\tomcat-7.0.69
pushd %CATALINA_HOME%\bin
call shutdown.bat
popd
rem git bisect first
git bisect %BISECT_CMD%
if ERRORLEVEL 1 call :resetHard
if ERRORLEVEL 1 goto error
rem setup iiq; run tomcat
call %scriptsdir%\quickSetup.cmd
rem I may want to conditionalize this later...
call starttc.cmd
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
