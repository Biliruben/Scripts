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
rem git bisect run c:\scripts\gitBisectRunScript.cmd %TEST_NG%
git bisect run c:\scripts\gitBisectRunScript.sh %TEST_NG%

git bisect reset
git bisect replay %temp%\findProblemHashResults.txt
echo %temp%\findProblemHashResults.txt:
type %temp%\findProblemHashResults.txt
