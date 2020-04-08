@echo off
echo Sturt!
for /f %%i in (alphaAlpha.txt) do (
    call sed "s/\$KEY\$/%%i/g" TaskDefinition_MissingMATemplate.xml > MissingMATDs\TaskDefinition_MissingMA_%%i.xml
)
echo And!
