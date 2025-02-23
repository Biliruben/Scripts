@call %scriptsDir%\doEcho.cmd
setlocal
if [] EQU [%1] goto cmdLineArgs
set identityID=%1
set HOSTNAME=localhost
set userCtx=james.smith:xyzzy
set userCtx=spadmin:admin
set httpCmd=http --auth %userCtx% --check-status --verify=no
set baseURL=http://%HOSTNAME%:8080/iiq2
set baseURL=http://%HOSTNAME%:8080/iiq8403
set restURL=%baseURL%/ui/rest


%httpCmd% GET "%restURL%/identities/%identityID%
rem %httpCmd% GET "%restURL%/quickLinks/View%%20Identity/identities/%identityID%/access/identityRoles"
rem %httpCmd% GET "%restURL%/quickLinks/View%%20Identity/identities/%identityID%/access/identityRoles"

goto eof

:cmdLineArgs
echo IdentityID must be passed in the command line
goto eof

:eof
