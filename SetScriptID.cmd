for /f "delims=: tokens=1,2,*" %%i in ("%time%") do set IDTime=%%i%%j%%k
for /f "tokens=1,*" %%i in ("%date%") do set IDDate=%%i%%j
for /f "delims=/ tokens=1,2,3" %%i in ("%IDDate%") do set ScrID=%%i%%j%%k%IDTime%
for /f "tokens=1,2" %%i in ("%ScrID%") do set ScrID=%%i%%j%random%
rem echo %ScrID%
