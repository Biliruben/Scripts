@echo off

rem Script to launch DbVisualizer by manually invoking Java

rem Please note that it's *not* recommended to launch DbVisualizer
rem with this script. Instead use the "dbvis.exe" launcher.

set DBVIS_HOME=c:\Program Files\DbVisualizer
set JAVA_EXEC=java

set CP=%DBVIS_HOME%\resources
set CP=%CP%;%DBVIS_HOME%\lib\*

rem Extract the version string
for /f "tokens=3" %%g in ('%JAVA_EXEC% -version 2^>^&1 ^| findstr /i "version"') do (
    set VERSION_STRING=%%g
)

rem Remove the double-quotes
set VERSION_STRING=%VERSION_STRING:"=%

rem Form JAVA_VER from major and minor number
for /f "delims=. tokens=1-3" %%v in ("%VERSION_STRING%") do (
    set JAVA_VER=%%v%%w
)

set MAX_PERM_SIZE=-XX:MaxPermSize=192m
if %JAVA_VER% gtr 17 set MAX_PERM_SIZE=

%JAVA_EXEC% -XX:CompileCommand=exclude,javax/swing/text/GlyphView,getBreakSpot -XX:StringTableSize=1000003 -Xmx2048M %MAX_PERM_SIZE% -Dsun.locale.formatasdefault=true -splash:"%DBVIS_HOME%\resources\images\ix3\dbvis-splash.png" -Ddbvis.home="%DBVIS_HOME%." -cp "%CP%" com.onseven.dbvis.DbVisualizerGUI %*
