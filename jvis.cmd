@echo off
rem Launches the stand-alone app of JVisualVM
rem start /b c:\Visualvm_213\bin\visualvm --jdkhome "c:\jdk1.8.0_45" --userdir %userprofile% --console suppress
start /b c:\Visualvm_213\bin\visualvm --jdkhome "%JAVA_HOME%" --console suppress
