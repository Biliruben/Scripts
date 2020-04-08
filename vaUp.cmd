@echo off
setlocal
pushd c:\gitroot\cloud-ssh\misc\vagrant
call vagrant up va
call vagrant status
popd
