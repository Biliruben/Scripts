@echo off
rem Gotta get a little Bash-y
rem Prune the previous file, existant or otherwise
rm -f %SSH_AUTH_SOCK%
call "C:\Program Files (x86)\Git\bin\ssh-agent.exe" -a %SSH_AUTH_SOCK% > c:\temp\sshAuthAgent-startup.log 2>&1
call "C:\Program Files (x86)\Git\bin\ssh-add.exe" %HOMEPATH%\.ssh\id_rsa
