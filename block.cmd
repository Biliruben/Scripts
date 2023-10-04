@echo off
rem 'block start finish'
setlocal
set FILENAME=%3
set HEAD_FILENAME=%FILENAME%.head
set BLOCK_FILENAME=%FILENAME%.block
set END=%2
set START=%1
set /a BLOCK=%END%-%START%
echo %FILENAME%: from line %START%, getting %BLOCK% lines
head -n %END% %FILENAME% > %HEAD_FILENAME%
tail -n %BLOCK% %HEAD_FILENAME% > %BLOCK_FILENAME%
del /q %HEAD_FILENAME%
echo Created %BLOCK_FILENAME%
endlocal
