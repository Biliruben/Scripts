@call doEcho
REM Inner working script to build one version
REM Inputs are:
REM %1: Tag or Hash
REM %2: Efix Version - pretty arbitrary value, actually

REM main
setlocal

set targetEfixHash=%1
set efixVersion=%2
set iiqSwitchOpt=%3
set propertiesFile=%~4
set branchTag=IIQSR867
set jiraTag=IIQSR-867

call switchIIQ %iiqSwitchOpt%

set efixBranchName=efix/tkirk/%branchTag%-%efixVersion%

rem check that repo exists
if not defined EFIX_REPO goto noEfixRepoDefined
if not exist "%EFIX_REPO%" goto noEfixRepo
rem pushd into that repo
pushd %EFIX_REPO%
rem
rem checkout Tag
rem checkout new Branch
git checkout -f -B %efixBranchName% %targetEfixHash%
if not exist "%EFIX_REPO%\build.user.properties" touch "%EFIX_REPO%\build.user.properties"
copy /y "%propertiesFile%" %EFIX_REPO%\build.user.properties
rem Add build.user.properties and commit it
git add -f build.user.properties
git commit -m "%jiraTag% - %efixVersion% - Efixins"

rem Head to the tag
git checkout -f %targetEfixHash%
call ant clean
rem Checkout our custom build properties
git checkout %efixBranchName% build.user.properties
git reset

rem Build!
call ant -Defix.efix_version=%efixVersion% autobuild-efix

popd
endlocal
goto eof
rem End of "main", next are all labels

:noEfixRepoDefined
echo EFIX_REPO env variable not defined!
exit /b 1
:noEfixRepo
echo %EFIX_REPO% not found!
exit /b 2
:eof
