@call c:\scripts\setEcho.cmd
setlocal
set DEFAULT_LINE_TOTAL=5
set USAGE=%0 filename [line, total_lines, hash]
if [%1] NEQ [] set FILE_NAME=%1
shift
if [%1] NEQ [] set LINE_START=%1
shift
if [%1] NEQ [] set LINE_TOTAL=%1
shift
if [%1] NEQ [] (
    set HASH=%1
) else (
    set HASH=HEAD
)

if not defined FILE_NAME (
  set ERROR_MSG=File name must be provided!
  goto error
)

if not exist %FILE_NAME% (
  set ERROR_MSG=%FILE_NAME% does not exist!
  goto error
)

set BLAME_PARAM= 
if defined LINE_START call :setupBlameParam

git blame %BLAME_PARAM% -n %FILE_NAME%
goto end

:setupBlameParam
if not defined LINE_TOTAL (
  set LINE_TOTAL=%DEFAULT_LINE_TOTAL%
)
if %LINE_TOTAL% LSS 1 (
  set ERROR_MSG=total_lines must be greater than 0
  goto error
)
set /a secondLine=%LINE_START%+%LINE_TOTAL%-1
set BLAME_PARAM=-L %LINE_START%,%secondLine% %HASH%
goto end

:error
echo %ERROR_MSG% 1>&2
echo %USAGE% 1>&2
endlocal
exit /b 1
goto end



:end
endlocal
