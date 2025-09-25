@call doEcho

setlocal
set HOSTNAME=localhost
set IIQ_TAG=iiq8421
set IIQ_PORT=8080
set LOGIN_NAME=amy.cox
set LOGIN_PASSWORD=xyzzy
REM Amy.Cox
set SEARCH_IDENTITY_ID=c0a856f89857183e8198570894960163
set SEARCH_KEY_WORD= 

if [%1] NEQ [] set SEARCH_KEY_WORD=%~1

http --auth %LOGIN_NAME%:%LOGIN_PASSWORD% GET http://%HOSTNAME%:%IIQ_PORT%/%IIQ_TAG%/ui/rest/requestAccess/currentAccessItems identityId==%SEARCH_IDENTITY_ID% limit==12 query==%SEARCH_KEY_WORD% quickLink==Request+Access searchType==Keyword start==0
