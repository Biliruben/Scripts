git checkout %1
git rm web\WEB-INF\efixes\IdenityIQ-IIQPB-1008-README.txt
mkdir web\WEB-INF\efixes
copy /y c:\temp\identityiq-IIQPB-1008-README.txt web\WEB-INF\efixes\
git add web\WEB-INF\efixes\identityiq-IIQPB-1008-README.txt
type efix.filelist | sed -s s/IdenityIQ-IIQPB-1008-README/identityiq-IIQPB-1008-README/ > c:\temp\efix.filelist
copy /y c:\temp\efix.filelist
call unix2dos efix.filelist
git add efix.filelist
echo %1
git commit
