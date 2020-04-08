@echo on
setlocal
set URL=%1
rem DATA_BINARY -- ala ruleName=Platform%%20Correlation%%20Rule&init=true
set DATA_BINARY=%2
set JSESSIONID=%3
set SPLUNK=%4
set CSRFTOKEN=%5
set XSRFTOKEN=%CSRFTOKEN%

rem reference
rem curl -H "Host: localhost:8080" -H "User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:54.0) Gecko/20100101 Firefox/54.0" -H "Accept: */*" -H "Accept-Language: en-US,en;q=0.7,en-GB;q=0.3" -H "X-XSRF-TOKEN: UwMlao6jaqNyTVXoH3OlDop6/HsBwOXhtOZ/XjW2tnQ=" -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" -H "X-Requested-With: XMLHttpRequest" -H "Referer: http://localhost:8080/identityiq/define/applications/application.jsf?appId=4028b8815ccb3f6a015ccb3fc5d702c0" -H "Cookie: JSESSIONID=DB8DF1378253CC0E516E1BBD01194AA1; splunkweb_csrf_token_8000=11458933411186028001; _ga=GA1.1.1469965297.1466442218; CSRF-TOKEN=UwMlao6jaqNyTVXoH3OlDop6/HsBwOXhtOZ/XjW2tnQ%3D" --data-binary "ruleName=Set%20Password%20Identity%20Rule&init=true" --compressed "http://localhost:8080/identityiq/include/rules/ruleEditorDataSource.json"

rem HTTPie example
rem http --auth james.smith:xyzzy GET "http://localhost:8080/identityiq/rest/taskResults"

curl -H "Host: localhost:8080" -H "User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:54.0) Gecko/20100101 Firefox/54.0" -H "Accept: */*" -H "Accept-Language: en-US,en;q=0.7,en-GB;q=0.3" -H "X-XSRF-TOKEN: %XSRFTOKEN%=" -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" -H "X-Requested-With: XMLHttpRequest" -H "Referer: http://localhost:8080/identityiq/dashboard.jsf" -H "Cookie: JSESSIONID=%JSESSIONID%; splunkweb_csrf_token_8000=%SPLUNK%; _ga=GA1.1.1469965297.1466442218; CSRF-TOKEN=%CSRFTOKEN%%%3D" --data-binary "%DATA_BINARY%" --compressed "%URL%"
echo %ERRORLEVEL% 
endlocal
