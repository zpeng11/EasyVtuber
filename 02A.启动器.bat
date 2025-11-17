@echo off
cd /D "%~dp0"
IF EXIST %~dp0envs\miniconda3\Scripts SET PATH=%~dp0envs\miniconda3\Scripts;%PATH%
call activate
call conda env list
call conda activate easyvtuber
call conda env list
set EZVTB_DATA=%~dp0data\models
IF "%FFMPEG_DIR%"=="" (
    echo Error: FFMPEG_DIR environment variable is not set.
    exit /b 1
)

pythonw launcher2.py