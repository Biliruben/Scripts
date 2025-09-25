@call doEcho
rem Sets the debug var to be compatible with the `jdb` command
set envArg=JAVA_OPTS
if [%1] NEQ [] set envArg=%1
set addrPort=5008
if defined DEBUG_PORT set addrPort=%DEBUG_PORT%
set trailArg= 
if %%envArg%% NEQ [] set trailArg=%%%envArg%%%
call set %%envArg%%=-Xrunjdwp:transport=dt_shmem,address=%addrPort%,server=y %trailArg%
call echo %%envArg%%=%%%envArg%%%%
rem Since we can't use setlocal, unset our working var manually
set trailArg=
