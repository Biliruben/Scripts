setlocal EnableDelayedExpansion
for /l %%i in (1,1,10) do call :doIt
goto eof

:doIt
echo %time% & http --auth-type bearer --auth KkFteS5Db3guVjZKK2VWM3liU1kzdUdEL1VZR2hEWGZYN0w0QVU3WFZYR214Qy85RnQrWjBiTWo2TkVwVDFEVnZjaVVqTEE2Z2N3djF3TDNiZlpiQWNTUldXelZFaEhrUFJvbmhyNVVoalNrSGppSkUzVkFrWG1MZHM4a3IxMkVQaEFiUCtoUWVLMG15YytUb0ZnRTVIeUdCSHU2NThRPT0= http://localhost:8080/iiq8521/rest/ping & echo !time!

:eof
