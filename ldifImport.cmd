@echo off
ldapmodify -D "cn=Manager,dc=maxcrc,dc=com" -w vi0let5 -r -c -f People.ldif
ldapmodify -D "cn=Manager,dc=maxcrc,dc=com" -w vi0let5 -r -c -f groups.ldif
