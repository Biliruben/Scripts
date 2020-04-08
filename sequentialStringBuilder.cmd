set test=flamFlarthAndFilth
echo %test:Flarth=SpitFlarth%


set string=$TASK$
echo %string%
for /f %%i in (c:\scripts\alphaAlphaAA-FE.txt) do set string=%string:$TASK$=%%i,$TASK$%"
