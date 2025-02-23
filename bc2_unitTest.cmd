@call doEcho.cmd

rem the purpose of this script is to create a shortcut to diffing
rem unittest "known state" files with the produced .tmp files. It
rem is expected that the user copy and paste the arguments:
rem 'path1/path2/file.txt and C:\path0\path1\path2\file.tmp' from
rem the unittest report and this script will tokenize and nomrlize
rem them to the correct relative paths for BC2 to diff.
rem
rem ex: sailpoint/api/provisioningProject7.xml and C:\GITRoot\iiq-ssh-local\tst4003868389528107732.tmp
rem becomes the expression:
rem     bc2 test\sailpoint\api\provisioningProject7.xml C:\GITRoot\iiq-ssh-local\tst4003868389528107732.tmp

setlocal
REM set DEBUG=echo
if not defined DEBUG set DEBUG=REM
rem Step 1: tokenize off of 'and'
set BASE_PARAMS=%*
rem Replaces ' and ' with '@'
set BASE_PARAMS=%BASE_PARAMS: and =@%
rem Removes double-quotes
set BASE_PARAMS=%BASE_PARAMS:"=%

%DEBUG% %BASE_PARAMS%
for /f "delims=@ tokens=1,2" %%i in ("%BASE_PARAMS%") do set TEST_FILE=%%i&set ACTUAL_FILE=%%j
%DEBUG% %TEST_FILE% :: %ACTUAL_FILE%

rem step 2: convert / to \
rem This only needs to be done to the Test File
set TEST_FILE=%TEST_FILE:/=\%
%DEBUG% Test file: %TEST_FILE%

rem step 2.1: check if TEST_FILE needs a leading `test\`
if NOT exist %TEST_FILE% set TEST_FILE=test\%TEST_FILE%
%DEBUG% Corrected Test File: %TEST_FILE%

rem step 3: diff
if not exist %TEST_FILE% goto noTestFile
if not exist %ACTUAL_FILE% goto noActualFile
call %SCRIPT_HOME%\bc2 "%TEST_FILE%" "%ACTUAL_FILE%"
goto eof

:noTestFile
echo Test File cannot be found: %TEST_FILE%
exit /b 1

:noActualFile
echo Actual File cannot be found: %ACTUAL_FILE%
exit /b 1

:eof
