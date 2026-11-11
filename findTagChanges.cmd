@call %SCRIPT_HOME%\doEcho.cmd
setlocal EnableExtensions EnableDelayedExpansion

rem ============================================================================
rem findTagChanges.cmd
rem
rem Usage:
rem   findTagChanges <fileList.txt> <baselineTag> [baselineTag2 ...]
rem
rem Example:
rem   findTagChanges someFileList.txt GA_8.4 GA_8.5
rem
rem For each baseline, compares each successive tag pair in the lineage
rem (e.g. GA_8.3 vs GA_8.3p1, then GA_8.3p1 vs GA_8.3p2, etc.) and reports
rem only new changes introduced in each step.
rem
rem Output columns:
rem   1) Tag
rem   2) Commit hash(es), one per line within the cell
rem   3) File path(s), one per line within the cell
rem ============================================================================

if "%~1"=="" goto :usage
if "%~2"=="" goto :usage

set "FILELIST=%~f1"
if not exist "%FILELIST%" (
    echo ERROR: File list not found: %FILELIST%
    exit /b 1
)

git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo ERROR: Current directory is not inside a git repository.
    exit /b 1
)

set "WORKDIR=%TEMP%\findTagChanges_%RANDOM%_%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%"
set "WORKDIR=%WORKDIR: =0%"
mkdir "%WORKDIR%" 2>nul

set "FILES=%WORKDIR%\files.txt"
set "CHANGED=%WORKDIR%\changed.txt"
set "COMMITS=%WORKDIR%\commits.txt"

call :build_file_list "%FILELIST%" "%FILES%"
if errorlevel 1 (
    rd /s /q "%WORKDIR%" 2>nul
    exit /b 1
)

shift
set "BASELINE_COUNT=0"

:baseline_loop
if "%~1"=="" goto :after_baselines
set /a BASELINE_COUNT+=1
call :process_baseline "%~1"
if errorlevel 1 (
    rd /s /q "%WORKDIR%" 2>nul
    exit /b 1
)
shift
goto :baseline_loop

:after_baselines
if %BASELINE_COUNT%==0 goto :usage

rd /s /q "%WORKDIR%" 2>nul
endlocal
exit /b 0

:usage
echo Usage: %~nx0 ^<fileList.txt^> ^<baselineTag^> [baselineTag2 ...]
echo.
echo Example:
echo   %~nx0 someFileList.txt GA_8.4 GA_8.5
exit /b 1

rem ---------------------------------------------------------------------------
rem Build a clean file list for git
rem ---------------------------------------------------------------------------
:build_file_list
set "SRC=%~1"
set "DEST=%~2"
> "%DEST%" (
    for /f "usebackq eol=# tokens=1* delims=" %%L in ("%SRC%") do (
        set "LINE=%%L"
        call :trim LINE
        if not "!LINE!"=="" echo(!LINE!
    )
)

set "COUNT=0"
for /f %%C in ('type "%DEST%" ^| find /c /v ""') do set "COUNT=%%C"
if "%COUNT%"=="0" (
    echo ERROR: No files found in %SRC%
    exit /b 1
)
exit /b 0

rem ---------------------------------------------------------------------------
rem Trim leading/trailing spaces from a variable named in %1
rem ---------------------------------------------------------------------------
:trim
set "VAR=%~1"
for /f "tokens=* delims= " %%A in ("!%VAR%!") do set "%VAR%=%%A"
if not "!%VAR%:~-1!"==" " goto :eof
set "%VAR%=!%VAR:~0,-1!"
goto :trim

rem ---------------------------------------------------------------------------
rem Process one baseline tag and all later tags in the same lineage
rem ---------------------------------------------------------------------------
:process_baseline
set "BASELINE=%~1"

git rev-parse --verify "refs/tags/%BASELINE%" >nul 2>&1
if errorlevel 1 (
    echo ERROR: Baseline tag not found: %BASELINE%
    exit /b 1
)

set "PREV=%BASELINE%"

for /f "delims=" %%T in ('git tag -l "%BASELINE%*" --sort^=version:refname') do (
    set "TAG=%%T"
    if /i not "!TAG!"=="%BASELINE%" (
        call :report_tag "!PREV!" "!TAG!"
        set "PREV=!TAG!"
    )
)
exit /b 0

rem ---------------------------------------------------------------------------
rem Emit one output row if any monitored files changed between PREV and TAG
rem ---------------------------------------------------------------------------
:report_tag
set "PREV=%~1"
set "TAG=%~2"

del "%CHANGED%" 2>nul
del "%COMMITS%" 2>nul

for /f "usebackq delims=" %%F in ("%FILES%") do (
    git diff --name-only "%PREV%" "%TAG%" -- "%%F" >> "%CHANGED%" 2>nul
)

if not exist "%CHANGED%" goto :eof

set "CHANGED_COUNT=0"
for /f %%C in ('type "%CHANGED%" ^| find /c /v ""') do set "CHANGED_COUNT=%%C"
if "%CHANGED_COUNT%"=="0" goto :eof

for /f "usebackq delims=" %%F in ("%CHANGED%") do (
    git log --format=%%H "%PREV%..%TAG%" -- "%%F" >> "%COMMITS%" 2>nul
)

if exist "%COMMITS%" (
    sort /unique "%COMMITS%" > "%COMMITS%.uniq" 2>nul
    move /y "%COMMITS%.uniq" "%COMMITS%" >nul
)

echo(
echo [TAG] %TAG%

echo [COMMITS]
if exist "%COMMITS%" (
    for /f "usebackq delims=" %%H in ("%COMMITS%") do echo %%H
) else (
    echo.
)

echo [FILES]
for /f "usebackq delims=" %%F in ("%CHANGED%") do echo %%F

echo ----
exit /b 0
