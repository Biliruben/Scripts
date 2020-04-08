@set ECHO=off
@echo %ECHO%
rem I got 99 problems and I'm pretty sure one of these hashes is one.
rem Use git bisect to isolate the problem hash using ant test to isolate
rem the defect. Relies on the caller to supply a testng XML file that executes a 
rem descrete test.
rem
rem While we can smartly guess at what ant tells us, we can still use an interactive
rem prompt to determine the bisect good/bad result.

rem Using git bisect between two hashes.
rem Parameter 1: the good hash (older)
rem Parameter 2: the bad hash (probably head)

setlocal

rem Debug variables to help me debug things
rem Uncomment to disable ant execution
rem set NO_ANT=true

set /a EXIT_CODE=0

set GOOD_HASH=%1
set BAD_HASH=%2
set TEST_NG=%3
set INTERACTIVE=%4

if not defined BAD_HASH (
    set EXIT_CODE=1
    echo Good and Bad hash ranges were not provided
)

if not defined TEST_NG (
    set EXIT_CODE=4
    echo Test NG custom XML was not provided
)
if %EXIT_CODE% GTR 0 exit /b %EXIT_CODE%

echo Good hash:
git bugz %GOOD_HASH%
if ERRORLEVEL 1 (
    set EXIT_CODE=2
    echo Good hash was not found!
)
if %EXIT_CODE% GTR 0 exit /b %EXIT_CODE%

echo ============================
echo Bad hash:
git bugz %BAD_HASH%
if ERRORLEVEL 1 (
    set EXIT_CODE=2
    echo Bad hash was not found!
)
if %EXIT_CODE% GTR 0 exit /b %EXIT_CODE%

rem Start git bisect wizard
git bisect start %BAD_HASH% %GOOD_HASH%


:mainLoop
echo ============================
if not defined NO_ANT call ant clean,dist
REM We've not run our test. An error here is a build error and invalid
if ERRORLEVEL 1 (
    git bisect skip
    goto mainLoop
)
if not defined NO_ANT call ant -DtestngBase=%TEST_NG% test
@echo %ECHO%
set PREVIOUS_ERROR=%ERRORLEVEL%
echo Interactive: %INTERACTIVE%
if defined INTERACTIVE (
    choice /C YNUS /M "Error found? Y = Error / N = Clean / U = Unknown / S = Stop"

    REM Remeber that the syntax 'if ERRORLEVEL n' means, "if ERRORLEVEL is n or greater"
    if ERRORLEVEL 4 (
        goto summarizeEnd
    ) 
    if ERRORLEVEL 3 (
        git bisect skip
        goto mainLoop
    ) 
    if ERRORLEVEL 2 (
        echo Good hash
        git bisect good
        goto mainLoop
    ) 
    if ERRORLEVEL 1 (
        echo Bad hash
        git bisect bad
        goto mainLoop
    ) else (
        REM Error level 0 means they hit ctrl-c during choice. Just end.
        goto end
    )
) else (
    REM Non-interactive mode. Use PREVIOUS_ERROR
    if %PREVIOUS_ERROR% GTR 0 (
        echo Bad hash
        git bisect bad
    ) else (
        echo Good hash
        git bisect good
    )
)

goto mainLoop

:interactive

goto end


:summarizeEnd
git bisect log
git bisect reset
git replay %temp%\findProblemHashResults.txt
goto end

:end

