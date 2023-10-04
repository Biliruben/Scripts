@echo off

rem Script to launch the command line interface for DbVisualizer

set DBVIS_HOME=c:\Program Files\DbVisualizer
set JAVA_EXEC=java

set CP=%DBVIS_HOME%\resources
set CP=%CP%;%DBVIS_HOME%\lib\*

%JAVA_EXEC% -Xmx2048M -Dsun.locale.formatasdefault=true -Djava.awt.headless=true -Ddbvis.home="%DBVIS_HOME%." -cp "%CP%" com.onseven.dbvis.DbVisualizerCmd %*
