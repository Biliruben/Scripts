@call %scriptsdir%\setEcho.cmd
set PROTECTED_FILE=c:\scripts\protectedGitFiles.txt
call git status
echo.
choice /T 30 /D N /M "Are you sure you want to reset your changes?"
if ERRORLEVEL 2 goto end
echo Resetting...
call git reset head
call %scriptsdir%\cleangitrej
for /f "tokens=1,*" %%i in ('git status --short ^| findstr /c:?? /b /v') do call :resetFile %%j
call git status
goto end

:resetFile
findstr /c:"%*" /b /e %PROTECTED_FILE% > nul 2>&1
if ERRORLEVEL 1 (
    echo Resetting %*
    git checkout %*
)

:end
