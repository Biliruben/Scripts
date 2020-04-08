rem This is here mostly for documentation
$ for /f "tokens=2" %%i in ('git status --short ^| findstr /c:" M" /b') do git add %%i
