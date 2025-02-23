@call doEcho
rem This will need to read a space delimited file to report on diffs
rem from one hash to another. That file might look something like
rem
rem GA_8.1 GA_8.1p1
rem GA_8.1p1 GA_8.1p2
rem GA_8.1p2 GA_8.1p3
rem 
rem That file is the argument to this script
setlocal

set diffsFile=diffs.txt
if [%1] EQU [] goto noParam
set hashFile=%~1
if not exist "%hashFile%" goto noFile
del /q %diffsFile%
if [%2] EQU [] (
    set files= 
) else (
    set files=%~2
    echo Diffing for files: %2>>%diffsFile%
)


rem Gets the short path to the file since spaces mess us up
for /f %%i in ('call echoShort "%hashFile%"') do set shortHashFile=%%i

for /f "tokens=1,2" %%i in (%shortHashFile%) do call :getDiffs %%i %%j
goto eof

:getDiffs
set hash1=%1
set hash2=%2

echo %hash1% :: %hash2%>>diffs.txt
echo git diff --compact-summary %hash1% %hash2% %files%
git diff --compact-summary %hash1% %hash2% %files%>>%diffsFile%
goto eof


:noParam
echo File of hashes must be provied
exit /b 1

:noFile
echo %hashFile% does not exist
exit /b /2

:eof
