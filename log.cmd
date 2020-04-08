@:: doEcho takes precedence over doLog when doEcho is on
::@setlocal
@if "%doLog%" == "" set doLog=off
@if "%doEcho%" == "on" set doLog=%doEcho%
@:: Append a new line if we're logging
@if %doLog% EQU on (
    echo %*
    echo.
)
::@endlocal
