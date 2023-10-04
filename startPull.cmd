@echo off

rem Fetches the current branch
rem git rev-parse --abbrev-ref HEAD
rem
rem Everything!
rem $ git status -sb
rem ## tkirk/IIQSR346-8.0p...origin/8.0p-develop
rem 

setlocal
rem set BROWSER_PATH=C:\Program Files (x86)\Google\Chrome\Application\chrome.exe
set BROWSER_PATH=C:\Program Files\Google\Chrome\Application\chrome.exe
rem Set this to an empty string if not desired
set BROWSER_OPTIONS=--new-window
set BASE_URL=https://github.com/sailpoint/identityiq/compare
set POST_URL=expand=1



for /f "tokens=1,2" %%i in ('git status -sb ^| findstr /c:"^##" /r') do SET branchTokensRaw=%%j
if not defined branchTokensRaw goto badLocation
echo %branchTokensRaw%
rem Replace '...' with a character that's illegal in a branch name, '~'
set branchTokens=%branchTokensRaw:...=~%
for /f "tokens=1,2 delims=~" %%i in ("%branchTokens%") do (
    SET remoteBranchRaw=%%j
    SET localBranch=%%i
)

rem delete the 'origin/' bit
SET remoteBranch=%remoteBranchRaw:origin/=%

rem echo %remoteBranch%
rem echo %localBranch%

set FULL_URL=%BASE_URL%/%remoteBranch%...%localBranch%?%POST_URL%
echo %FULL_URL%

call "%BROWSER_PATH%" %BROWSER_OPTIONS% "%FULL_URL%"
endlocal

goto eof

:badLocation
echo Not in GIT repository
exit /b 1

:eof
