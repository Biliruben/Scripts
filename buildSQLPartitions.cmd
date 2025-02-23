@echo off
setlocal EnableDelayedExpansion
rem replace this SQL with yours
rem set SQL_PART=select 100kident500kent.acctId, 100kident500kent.firstName, 100kident500kent.lastName, 100kident500kent.middleInit, 100kident500kent.title, 100kident500kent.region, 100kident500kent.department, 100kident500kent.email, 100kident500kent.groups, 100kident500kentmgremp.manager from 100kident500kent join 100kident500kentmgremp on 100kident500kent.acctId = 100kident500kentmgremp.employee where acctId like 'SQL_PART_REPLACE%%' order by 100kident500kent.acctId;
rem set SQL_PART=select acctId, empId, firstName, lastName, middleInit, title, region, department, email, manager from scaleidentity_180k left join scaleidentity_180k_mgr on employee = acctId where acctId like 'SQL_PART_REPLACE%%' order by acctId
set SQL_PART=select acctId, IIQSourceApplication, indexCol, entitlement from tk_scale_acct_50 where acctId like 'SQL_PART_REPLACE%%' order by indexCol
for /f %%k in (%scriptsdir%\alphaAlpha.txt) do call :doIt %%k
endlocal
goto eof

:doIt
set bit=%1
echo !SQL_PART:SQL_PART_REPLACE=%bit%!

:eof
