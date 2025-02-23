set fileName=%1
set hash=%2

rem reset the current one
git reset %fileName%

rem check out the old one
git checkout %hash% %fileName%
