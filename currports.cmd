@echo off
rem netstat -a -n -o | findstr /c:443

netstat -a -n -o | findstr /c:%1
tasklist /svc
