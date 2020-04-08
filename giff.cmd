@echo off
if [%1] NEQ [] (
    git difftool %*
) else (
    git difftool
)
