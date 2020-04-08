@call %scriptsdir%\setEcho.cmd
setlocal
set PROTECTED_FILE=c:\scripts\protectedGitFiles.txt
for /f "tokens=1,*" %%i in ('git status --short ^| findstr /c:?? /b /v') do (
    findstr /c:%%j /b /e %PROTECTED_FILE% > nul 2>&1
    if ERRORLEVEL 1 echo %%j
)

