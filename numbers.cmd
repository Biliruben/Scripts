@ECHO OFF
SET /a _rand=%RANDOM%*500/32768+1
ECHO Random number in range 1-500=%_rand% 

