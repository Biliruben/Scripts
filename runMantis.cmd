@echo off
pushd %GIT_HOME%\mantis-ssh
call gradlew build :mantis-dev-server:run -x assemble -x test
popd