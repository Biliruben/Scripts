@echo on
REM FART: Find And Replace Text
REM It's a wrapper to sed. Just fucking use sed!
set FILE=%1
set OLD_BUSTED=%2
set NEW_HOTNESS=%3
setlocal
call sed "s/%OLD_BUSTED%/%NEW_HOTNESS%/g" %FILE%
endlocal
goto end


:end
