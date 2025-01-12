@echo off
cd /D "%~dp0"
IF EXIST %~dp0envs\miniconda3\Scripts SET PATH=%~dp0envs\miniconda3\Scripts;%PATH%
call activate
call conda env list
call conda activate ezvtb_rt_venv
call conda env list

IF not EXIST %~dp0launcher.json call python ezvtb_rt_interface.py

pythonw launcher2.py