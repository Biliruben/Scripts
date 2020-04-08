@echo off

rem first copy the custom task to the build
rem
rem Then copy the build to the two VM tomcats
rem

set BUILD_DIR=%CD%\build
set CUSTOM_TASK=c:\gitroot\sp-toolset\bin\sailpoint\task\IIQETN5544_TaskExecutor.class
set FIX_CLASSES=%BUILD_DIR%\WEB-INF\classes\sailpoint\api\Aggregator*.class
set VM1=\\172.16.40.151\C
set VM2=\\172.16.40.164\C
set VM_DEPLOY=\tomcat\webapps\identityiq

if not exist %BUILD_DIR% (
    echo %BUILD_DIR% does not exist!
    exit /b 1
)

xcopy /e /a  /y /z %BUILD_DIR%\* %VM1%\%VM_DEPLOY%
xcopy /e /m  /y /z %BUILD_DIR%\* %VM2%\%VM_DEPLOY%
REM copy /y %BUILD_DIR%\classes\iiq.properties %VM1%\%VM_DEPLOY%\WEB-INF\classes
REM copy /y %BUILD_DIR%\classes\iiq.properties %VM2%\%VM_DEPLOY%\WEB-INF\classes
REM copy /y %CUSTOM_TASK% %BUILD_DIR%\WEB-INF\classes\sailpoint\task
REM copy /y %FIX_CLASSES% %VM1%\%VM_DEPLOY%\WEB-INF\classes\sailpoint\api
REM copy /y %FIX_CLASSES% %VM2%\%VM_DEPLOY%\WEB-INF\classes\sailpoint\api
copy /y %CUSTOM_TASK% %VM1%\%VM_DEPLOY%\WEB-INF\classes\sailpoint\task
copy /y %CUSTOM_TASK% %VM2%\%VM_DEPLOY%\WEB-INF\classes\sailpoint\task
