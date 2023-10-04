@echo off

setlocal EnableDelayedExpansion
for %%i in (WideWide*mp4) do call :renameFile "%%i"


goto eof
:renameFile

set currentFileName=%1
set currentFileNameBase=%~n1
echo fileName = %currentFileName%
echo base = %currentFileNameBase%
set clipName=!currentFileNameBase:WideWide - =!
echo clip = %clipName%
ren "WideWide - %clipName%.mp4" "!clipName: =!-1-Wide.mp4"
ren "TightTight - %clipName%.mp4" "!clipName: =!-2-Tight.mp4"
ren "End ZoneEnd Zone - %clipName%.mp4" "!clipName: =!-3-EZ.mp4"


:eof
