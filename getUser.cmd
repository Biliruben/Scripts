@call %scriptsDir%\doEcho.cmd
setlocal
set HOSTNAME=localhost
set userCtx=james.smith:xyzzy
set httpCmd=http --auth %userCtx% --check-status --verify=no
set baseURL=http://%HOSTNAME%:8080/iiq
set restURL=%baseURL%/ui/rest
set identityID=c0a85667863d132881863d4179654064

rem %httpCmd% GET "%restURL%/identities/%identityID%
echo %httpCmd% GET "%restURL%/quickLinks/View%%20Identity/identities/%identityID%/access/identityRoles"
%httpCmd% GET "%restURL%/quickLinks/View%%20Identity/identities/%identityID%/access/identityRoles"
