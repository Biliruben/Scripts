@echo off
cd /d c:\GITRoot\iiq-ssh-local
for /f %%i in (%scriptsdir%\git.branches) do call :pull %%i
goto end

:pull
echo Checkingout %1
git checkout %1 -f
git pull -v --progress origin %1
goto end

:end
