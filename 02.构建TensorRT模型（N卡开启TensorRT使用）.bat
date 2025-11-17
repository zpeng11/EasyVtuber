@echo off
cd /D "%~dp0"
IF EXIST %~dp0envs\miniconda3\Scripts SET PATH=%~dp0envs\miniconda3\Scripts;%PATH%
call activate
call conda env list
call conda activate easyvtuber
call conda env list
set EZVTB_DATA=%~dp0data\models

python -c "from ezvtb_rt.trt_utils import check_build_all_models; check_build_all_models()"

pause