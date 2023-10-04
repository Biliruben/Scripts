@call doEcho
setlocal EnableDelayedExpansion

set issue=%1
set SRC_DIR=c:\campaigns\DNDBeyond
set TGT_DIR=.

call clean

for %%i in (%SRC_DIR%\*-issue%issue%.*) do call :copyFile %%~nxi
goto eof

:copyFile
rem target file name is the same name without the -issueNNN
set srcFileName=%1
set srcLibFileName=!srcFileName:Lib_=Lib-!
set tgtFileName=!srcLibFileName:-issue%issue%=!
echo %srcFileName% --^> %tgtFileName%
copy /y %SRC_DIR%\%srcFileName% %TGT_DIR%\%tgtFileName%
goto eof

:eof
