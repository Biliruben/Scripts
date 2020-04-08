@echo off
rem For all files matching the inbound filter (if any), call
rem IIQ console to import them

if [%1] neq [] (set FILE_FILTER=%1
) else (
    set FILE_FILTER=*.xml
)
for %%i in (%FILE_FILTER%) do echo import "%%i" >> import.iiq

call iiq console < import.iiq
