rem @echo off
rem Wrapper script for git show with fancy formatting
rem This script only passes along the command line parameters and thus
rem doesn't care what you sent

rem The double %% you see here is Windows batch's way of escaping the
rem variable syntax.
git show --name-only --format="%%nHash: %%H%%nAuthor: %%an%%nDate:   %%cd%%n%%n     %%s"
