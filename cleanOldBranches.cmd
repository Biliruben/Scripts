@if defined doEcho (
    @echo %doEcho%
) else (
    @echo off
)

if [%1] EQU [] goto noOptsGiven
setlocal EnableDelayedExpansion

rem set Debug to 'echo' to enable read-only mode
if not defined DEBUG set DEBUG=
if "%DEBUG%"=="echo" echo Read-only mode enabled

rem 15552000 is 180 days in seconds
if not defined REL_TIME_THRESHOLD set REL_TIME_THRESHOLD=15552000

rem Branches in the protection file are not messed with
set PROTECTION_FILE=c:\scripts\protectedBranches.txt


call :calculate_threshold

rem Valid prefixes are:
rem EFIX
rem SET
rem IIQSR
rem IIQTC
rem IIQETN
set JIRA_PREFIX=%1
call %scriptsdir%\applyJiraPrefixToTag.cmd
if [%tagPrefix%] == [] goto noTagGiven

set branch_prefix=tkirk/%JIRA_PREFIX%
for /f %%i in ('call git branch ^| findstr /b /i /c:"  %branch_prefix%"') do call :check_branch %%i
goto eof


:calculate_threshold
rem get current time in Unix seconds, subtract 6 months of seconds from it
for /f "delims=." %%i in ('call powershell get-date -UFormat "%%s"') do set _currTime=%%i
set /a MAX_AGE=%_currTime%-%REL_TIME_THRESHOLD%
echo MAX_AGE=%MAX_AGE%
goto eof


:check_branch
set local_branch=%1
echo Analyzing %local_branch%
findstr /c:%local_branch% %PROTECTION_FILE% > null 2>&1
if %ERRORLEVEL% == 0 echo %local_branch% is protected && goto eof
for /f %%i in ('call git log --pretty^=format:%%at %local_branch% -n1') do set branch_time=%%i
if %branch_time% LEQ %MAX_AGE% call :clean_branch %local_branch%
goto eof

:clean_branch
echo Cleaning %local_branch%
call :clean_database %local_branch%

rem Then dump the branch
%DEBUG% git branch -D %local_branch%

rem Then dump any remote branch
%DEBUG% git push origin --delete %local_branch%
goto eof


:clean_database
echo Checking database for %local_branch%
rem dump the databases matching this branch's bug number; versions are irrelevant
set _token1=!local_branch:%branch_prefix%=!
for /f "delims=-" %%i in ("%_token1%") do set bug_num=%%i
for /f %%i in ('mysql -N -B -e "select distinct(Db) from db where Db like '%%_%tagPrefix%%bug_num%'" mysql') do call :drop_database %%i
goto eof

:drop_database
echo Cleaning DB %1
%DEBUG% mysql -N -B -e "drop database %1"
%DEBUG% mysql -N -B -e "drop user if exists '%1'@'%%'"
%DEBUG% mysql -N -B -e "drop user if exists '%1'@'localhost'"

goto eof


:noOptsGiven
echo No Jira prefix provided: set, efix, iiqsr, iiqtc, iiqetn
exit /b 1

:noTagGiven
echo Jira prefix (%JIRA_PREFIX%) does not map to a valid tag
exit /b 2

:eof
