@echo off
for /d %%i in (*) do (
pushd %%i
gunzip *
popd
)