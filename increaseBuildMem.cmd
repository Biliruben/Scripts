@if defined doEcho (
    @echo %doEcho%
) else (
    @echo off
)
rem if not exist "C:\Program Files (x86)\Git\bin\sed.exe" (
    rem echo SED not found!
    rem exit /b 1
rem )
if not exist build.xml (
    echo build.xml not found!
    exit /b 2
)
setlocal
if [%1] EQU [] (
    set maxMem=2048m
) else (
    set maxMem=%1
)
call %scriptsdir%\SetScriptID.cmd
set tmpBuildFile=%TEMP%\_tmpBuild_%ScrID%.xml
sed 's/memoryMaximumSize="768m"/memoryMaximumSize="%maxMem%"/' build.xml > %tmpBuildFile%
move /y %tmpBuildFile% build.xml
endlocal
