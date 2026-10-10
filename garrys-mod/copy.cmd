@echo off

@REM Copy SourceConfig
set "source=%~dp0"
set "dest=E:\Program Files\Steam\steamapps\common\GarrysMod"
xcopy "%source%" "%dest%" /B /E /Y /EXCLUDE:%~dp0\xcopy_exclude.txt
pause
