@call %SCRIPT_HOME%\doEcho.cmd
:: Echo must be off!
::
:: After its initial development, logging is a very special case activity
:: and the debugger must remark this out to enable tracingt
set doLog=off
:: First consumer of log.cmd: Set doLog=on for debug statements
::  Remeber: doEcho overrides doLog. Instead of doEcho=off, unset doEcho
::
::  Test cmd: $ getOpts "-donkey: -turkish:delight" -donkey -cummy sure -turkish stale -- This is the end, my friend
::
:: Don't wrap script in setlocal. We need a scope outside of this
:: Usage: "key" options, ala
:: The key defines default values for options and flag only options.
:: "-username:/ -option2:"" -option3:"three word default" -flag1: -flag2:" -flag1 -username:tkirk
::
:: TODO: validate key! Definitions must have a ':'
:: TODO: Strip trailing spaces; If opts end with a --, just strip it also
::
:: The output of this script will be SET commands. The consumer can use the for /f loop to
:: effectively set the variables within their local environment
setlocal EnableDelayedExpansion
:: MUST unset doEcho after setlocal as to not fuss w/ a caller's value
set doEcho=
:: Clear errMsg, just in case
set errMsg=
if [%2] EQU [] set errMsg=getOpts: "key" options
if defined errMsg echo %errMsg%
if defined errMsg exit /b 1

set _OPTS=%~1
:: Set defaults by iterating over _OPTS first delimiting on space; For each token, "split" on colon(:)
:: and set the key value pair, removing quotes
call %scriptsdir%\log.cmd Options key: "%_OPTS%"
if ERRORLEVEL 1 exit /b 1
for %%i in (%_OPTS%) do (
    call %scriptsdir%\log.cmd Parsing key %%i
    for /f "tokens=1,* delims=:" %%a in ("%%i") do set "%%a=%%~b"
)

set EXIT_PARAMS=@
:loop
call %scriptsdir%\log.cmd Evaluating option: %2
set option=%~2
if "%option%" == "--" call :doTail %*
if not "%option%"=="" (
    set "test=!_OPTS:*%option%:=! "
    call %scriptsdir%\log.cmd test -- delayed -- = "!test!"
    if "!test!"=="%_OPTS% " (
        rem Error!
        call log Error: Invalid option %option%
    ) else if "!test:~0,1!"==" " (
        call %scriptsdir%\log.cmd "%option%" is a flag
        rem Set the flag option using the option name.
        rem The value doesn't matter, it just needs to be defined.
        set "%option%=1"
    ) else (
        call %scriptsdir%\log.cmd "%option%" is an option with value "%3"
        rem Set the option value using the option as the name
        rem and the next arg as the value.
        set "%option%=%~3"
        shift /2
    )
    shift /2
    goto :loop
)

call %scriptsdir%\log.cmd Final options are:
rem for /f "delims=:" %%i in ('set -') do echo set "%%i"
for /f "delims=:" %%i in ('set -') do call :appendExitParams "%%i"
rem if NOT "%_tail%"=="" echo set "_tail=%_tail%"
if NOT "%_tail%"=="" set EXIT_PARAMS=%EXIT_PARAMS% & set "_tail=%_tail%"
call %scriptsdir%\log.cmd ...with tail: "%_tail%"
goto end

:appendExitParams
set EXIT_PARAMS=%EXIT_PARAMS% & set %1
goto end

:doTail
call %scriptsdir%\log.cmd Entering doTail: %*
set fullLine=%*
set _tail=!fullLine:*-- =!
if "%_tail%" == "%fullLine%" set _tail=
set option=
call %scriptsdir%\log.cmd Exiting doTail: _tail = "%_tail%"
goto eof

:end
endlocal & %EXIT_PARAMS%

:eof
