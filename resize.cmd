@echo off
rem first arg is the file filter, heck, so is the last arg
set filePattern=%1

for %%i in (%filePattern%) do call :rename "%%i"
goto end

:rename
convert -resize 1280 %1 %~n1_1280%~x1


:end
