@if defined doEcho @echo %doEcho%
if not defined IIQ_VERSION (
    set IIQ_VERSION=%~1
    if not defined IIQ_VERSION (
        echo IIQ_VERSION not defined; Must be an environment variable or passed in
        exit /b 2
    )
)
setlocal
if not defined DIFF_DIRECTORY set DIFF_DIRECTORY=c:\etn_data\baseDiffs
if not defined ScrID call %SCRIPT_HOME%\SetScriptID.cmd
if not defined BASE_CD call %SCRIPT_HOME%\getCurrentDirectory.cmd
set iiqVersionP=%IIQ_VERSION%p
if /I %IIQ_VERSION% EQU develop set iiqVersionP=%IIQ_VERSION%
rem Find the suggested diff and merge it
set diffFile=%DIFF_DIRECTORY%\%iiqVersionP%-BaseConfig.diff
echo Merging diff file: %diffFile%
call :setTempDiff
if exist "%diffFile%" (
    rem Do a search and replace of {GIT_REPO} into a temp difffile
    call sed "s/{GIT_REPO}/%BASE_CD%/g" %diffFile% > %_tempDiff%
    dos2unix %_tempDiff%
    git apply --whitespace nowarn --reject %_tempDiff%
    if not defined NO_DELETE (
        del /f /q %_tempDiff%
    ) else (
        echo Preserving %_tempDiff% per NO_DELETE environment variable
    )
) else (
    echo Diff file not found!
    echo.
)
goto end

:setTempDiff
set _tempDiff=%TEMP%\%BASE_CD%_%ScrID%.diff
echo tempDiff: %_tempDiff%
goto end

:end
endlocal
exit /b %ERRORLEVEL%
