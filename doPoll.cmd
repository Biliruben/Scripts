@echo off

setlocal

rem set POLL_ID=5c05ad0ce4b08d97cd04bc17
rem set MULT_RESP=3
set POLL_ID=5c06e02be4b0e6b47c3fcdbe
set MULT_RESP=2

set HOSTNAME=www.easypolls.net
call %scriptsDir%\SetScriptID.cmd
set JQUERY1=jQuery%ScrId:Tue=%
set JQUERY2=%JQUERY1:.=%
set tempFileName=%TEMP%\%ScrId%.txt
call %scriptsDir%\getUnixTime.cmd
set UNIX_TIME=%UNIX_TIME%999
set JQUERY=%JQUERY2%_%UNIX_TIME%
set COOKIE_JAR=%TEMP%\cookie_jar.%ScrId%.txt

curl -c %COOKIE_JAR% -H "Host: www.easypolls.net" -H "Accept: text/javascript, application/javascript, application/ecmascript, application/x-ecmascript, */*; q=0.01" -H "X-Requested-With: XMLHttpRequest" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.110 Safari/537.36" -H "Referer: http://www.easypolls.net/poll.html?p=%POLL_ID%" -H "Accept-Language: en,en-GB;q=0.9,en-US;q=0.8,fr;q=0.7" "http://www.easypolls.net/poll?jsoncallback=%JQUERY%&pollId=%POLL_ID%&command=getPoll&_=%UNIX_TIME%" | sed -e s/^%JQUERY%(// | sed -e s/);// | jq .pollKey > %tempFileName%

for /f %%i in (%tempFileName%) do set POLL_KEY=%%~i

sleep 1

echo pollKey=%POLL_KEY%

curl -b %COOKIE_JAR% -H "Host: www.easypolls.net" -H "Accept: text/javascript, application/javascript, application/ecmascript, application/x-ecmascript, */*; q=0.01" -H "X-Requested-With: XMLHttpRequest" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.110 Safari/537.36" -H "Referer: http://www.easypolls.net/poll.html?p=%POLL_ID%" -H "Accept-Language: en,en-GB;q=0.9,en-US;q=0.8,fr;q=0.7" "http://www.easypolls.net/poll?jsoncallback=%JQUERY%&multResp=%MULT_RESP%&pollId=%POLL_ID%&pollKey=%POLL_KEY%&command=saveResponse&_=%UNIX_TIME%"
echo.
del /q %COOKIE_JAR%
del /q %tempFileName%
