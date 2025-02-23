@call doEcho
set envArg=JAVA_OPTS
if [%1] NEQ [] set envArg=%1
set trailArg= 
if %%envArg%% NEQ [] set trailArg=%%%envArg%%%
call set %%envArg%%=-Xdebug -Xrunjdwp:transport=dt_socket,address=5008,server=y %trailArg%
call echo %%envArg%%=%%%envArg%%%%
rem Since we can't use setlocal, unset our working var manually
set trailArg=
