@echo off
rem Call this with a file pattern (or none) and those files will have
rem a checksum created as 'originalFileName'-CHECKSUM.txt
setlocal
set SUFFIX=-CHECKSUM.txt
set HASH_TYPE=SHA256
set FILE_PATTERN=%1
if [%FILE_PATTERN%] == [] set FILE_PATTERN=*
rem old 'n busted
rem for %%i in (%FILE_PATTERN%) do call certutil -hashfile %%i %HASH_TYPE% > %%~ni%SUFFIX%
for %%i in (%FILE_PATTERN%) do (
    echo Hash: SHA256 > %%~ni%SUFFIX%
    call sha256sum %%i | sed -e s/^*// >> %%~ni%SUFFIX%
)

endlocal
