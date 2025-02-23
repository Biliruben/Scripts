setlocal
@if not defined doEcho set doEcho=off
@echo %doEcho%
echo.
echo IIQ_VERSION=%IIQ_VERSION%
echo IIQ_BUG=%IIQ_BUG%
echo GIT_REMOTE=%GIT_REMOTE%
echo PULL_BRANCH=%PULL_BRANCH%
if defined MERGE_HASH echo MERGE_HASH=%MERGE_HASH%
if defined NO_STASH echo NO_STASH=%NO_STASH%
echo ANT_HOME=%ANT_HOME%
echo ANT_TASKS=%ANT_TASKS%
echo SCRIPT_HOME=%SCRIPT_HOME%
echo IIQ_TEST_HOME=%IIQ_TEST_HOME%
echo IIQ_DEMO_DATA=%IIQ_DEMO_DATA%
echo REPO_HOME=%REPO_HOME%
echo IIQ_TAG=%IIQ_TAG%
echo AFTER_CMD=%AFTER_CMD%
echo local_branch=%local_branch%
echo JAVA_HOME=%JAVA_HOME%
echo INIT_IMPORT_FILE=%INIT_IMPORT_FILE%
echo INIT_EXEC_FILE=%INIT_EXEC_FILE%
echo.
endlocal
