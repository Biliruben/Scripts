@echo off
rem Call this with a file pattern (or none) and those files will have
rem a checksum created as 'originalFileName'-CHECKSUM.txt
setlocal
set SUFFIX=-CHECKSUM.txt
set HASH_TYPE=SHA256
set FILE_PATTERN=%1
if [%FILE_PATTERN%] == [] set FILE_PATTERN=*
for %%i in (%FILE_PATTERN%) do call certutil -hashfile %%i %HASH_TYPE% > %%~ni%SUFFIX%

endlocal
