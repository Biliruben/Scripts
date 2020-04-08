@echo off
:: Crank up Oracle, yo!
echo Are you admin?
choice
if ERRORLEVEL 2 goto error
call :startService OracleServiceBOO
call :startService OracleOraDb11g_home1TNSListener
call :startService Oraclec_ora_trey~1.kir_product_112~1.0_dbhome_1ConfigurationManager
call :startService OracleDBConsoleboo
call :startService OracleJobSchedulerBOO
call :startService OracleMTSRecoveryService

goto eof

:startService
echo Starting service %1
net start %1
goto eof


:error
echo K, bye!
exit /b 2

:eof
