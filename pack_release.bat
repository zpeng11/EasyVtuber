@echo on
cd /D "%~dp0"

if not exist "envs" mkdir envs
if not exist "envs\miniconda3" mkdir envs\miniconda3

IF not EXIST %~dp0envs\miniconda3\Scripts (
    @RD /S /Q %~dp0envs\miniconda3
    mkdir %~dp0envs\miniconda3
    echo "Downloading miniconda..."
    powershell -Command "(New-Object Net.WebClient).DownloadFile('https://repo.anaconda.com/miniconda/Miniconda3-py310_24.9.2-0-Windows-x86_64.exe', '.\envs\miniconda3.exe')"

    echo "Installling minconda..."
    start /wait "" %~dp0envs\miniconda3.exe /S /AddToPath=0 /RegisterPython=0 /InstallationType=JustMe /D=%~dp0envs\miniconda3
    echo "Successfully install minconda"
    del envs\miniconda3.exe
)

SET PATH=%~dp0envs\miniconda3\Scripts;%PATH%

call activate
call conda env list
call conda update -y --all
call conda create -n ezvtb_rt_venv -c conda-forge conda-pack python=3.10 -y
call conda activate ezvtb_rt_venv
call conda env list

call conda install -y nvidia/label/cuda-12.6.3::cuda-nvcc-dev_win-64
call conda install -y pycuda -c https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/ 

call conda-pack -n ezvtb_rt_venv -o %~dp0envs\python_embedded --format no-archive


SET PATH=%~dp0envs\python_embedded;%~dp0envs\python_embedded\Scripts;%~dp0envs\python_embedded\Library\bin;%PATH%

call python -m pip install --upgrade pip wheel -i https://mirrors.aliyun.com/pypi/simple/
echo yes|python -m pip install nvidia-cudnn-cu12 -i https://mirrors.aliyun.com/pypi/simple/

echo yes|pip install tensorrt_cu12_libs==10.6.0 tensorrt_cu12_bindings==10.6.0 tensorrt==10.6.0 --extra-index-url https://pypi.nvidia.com

call python -m pip install -r requirements.txt --no-warn-script-location -i https://mirrors.aliyun.com/pypi/simple/

@REM To verify if environment works
@REM call python ezvtb_rt_interface.py 

@REM Clean up step
@REM for /R %%f in (*.trt) do del "%%f"
@REM @RD /S /Q %~dp0envs\miniconda3
pause