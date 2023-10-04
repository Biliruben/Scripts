rem Given a list of choices with arbitrary values, build
rem a string suitable as a prompt for the 'choice' command.
rem Store the prompt in a local env var
rem Create reverse mapping vars for each choice, each in
rem a local env var
rem
rem The caller is expected to use setlocal as to prevent
rem these vars from polluting the command line.

rem given a list of 8 11 14 17
rem make: choiceStr = "1234"
rem       promptStr = 1 = 8, 2 = 11, 3 = 14, 4 = 17
rem       choiceOf8 = 1
rem       choiceOf11 = 2
rem       choiceOf14 = 3
rem       choiceOf17 = 4

set _choiceCount=0
set choiceStr=
set promptStr=
:beginPop
if /i [%1] EQU [] goto :end
set /a _choiceCount=_choiceCount + 1
set choiceStr=%choiceStr%%_choiceCount%
if /i ["%promptStr%"] NEQ [""] set promptStr=%promptStr%, 
set promptStr="%promptStr%%_choiceCount% = %1"
rem remove the quotes
set promptStr=%promptStr:"=%
set choiceOf%1=%_choiceCount%
shift
goto beginPop

:end
