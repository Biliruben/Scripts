setlocal
set DEFAULTS_FILE=C:\Program Files\MySQL\MySQL Server 5.7\my.ini
rem set DEFAULTS_FILE=C:\ProgramData\MySQL\MySQL Server 8.0\my.ini
rem set DO_CMD=mysqld --defaults-file="%DEFAULTS_FILE%" --standalone --general_log --general_log_file=c:\temp\mysqld.log --log_output=FILE --datadir="c:\ProgramData\MySQL\MySQL Server 5.7\Data"
set DO_CMD=mysqld --skip-grant-tables --standalone --general_log --general_log_file=c:\temp\mysqld.log --log_output=FILE --datadir="c:\ProgramData\MySQL\MySQL Server 5.7\Data"
call %DO_CMD%
