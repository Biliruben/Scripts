@echo off
setlocal EnableDelayedExpansion
rem replace this SQL with yours
rem set SQL_PART=select 100kident500kent.acctId, 100kident500kent.firstName, 100kident500kent.lastName, 100kident500kent.middleInit, 100kident500kent.title, 100kident500kent.region, 100kident500kent.department, 100kident500kent.email, 100kident500kent.groups, 100kident500kentmgremp.manager from 100kident500kent join 100kident500kentmgremp on 100kident500kent.acctId = 100kident500kentmgremp.employee where acctId like 'SQL_PART_REPLACE%%' order by 100kident500kent.acctId;
set SQL_PART=SELECT 1midentities.acctId,1midentities.firstName,1midentities.lastName,1midentities.middleInit,1midentities.title,1midentities.region,1midentities.department,1midentities.email,1midentmgremp_10.manager FROM 1midentities LEFT JOIN 1midentmgremp_10 ON 1midentities.acctId = 1midentmgremp_10.employee where acctId like 'SQL_PART_REPLACE%%'
for /f %%k in (%scriptsdir%\alpha.txt) do call :doIt %%k
endlocal
goto eof

:doIt
set bit=%1
echo !SQL_PART:SQL_PART_REPLACE=%bit%!

:eof
