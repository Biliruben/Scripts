@echo off
setlocal
if [%1] EQU [] (
   echo Please provide search term, jackass
   goto eof
) else (
    set REQ_IDENTITY_SEARCH=%1
)
if not defined AUTH_USER set AUTH_USER=james.smith
if not defined AUTH_PASSWORD set AUTH_PASSWORD=xyzzy
if not defined URL_HOST set URL_HOST=localhost
if not defined URL_PORT set URL_PORT=8080
if not defined URL_BASE set URL_BASE=iiq
if not defined REQ_LIMIT set REQ_LIMIT=12

set httpCmd=http --auth %AUTH_USER%:%AUTH_PASSWORD% "http://%URL_HOST%:%URL_PORT%/%URL_BASE%/ui/rest/quickLinks/View+Identity/identities" limit==%REQ_LIMIT% nameSearch==%REQ_IDENTITY_SEARCH%
echo %httpCmd%
%httpCmd%



:eof
