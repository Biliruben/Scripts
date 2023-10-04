setlocal
set DEFAULTS_FILE=C:\Program Files\MySQL\MySQL Server 5.7\my.ini
set DO_CMD=mysqld --skip-grant-tables --defaults-file="%DEFAULTS_FILE%" --standalone --general_log --general_log_file=c:\temp\mysqld.log --log_output=FILE
set DO_CMD=mysqld --skip-grant-tables --standalone --general_log --general_log_file=c:\temp\mysqld.log --log_output=FILE --datadir="c:\ProgramData\MySQL\MySQL Server 5.7\SadData"
call %DO_CMD%
