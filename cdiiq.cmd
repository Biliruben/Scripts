@echo off
set tail= 
if [%1] NEQ [] set tail=%*
pushd "C:\GITRoot\iiq-ssh-local\build\%tail%"
