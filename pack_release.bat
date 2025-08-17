@echo on
REM ========================================================================
REM IMPORTANT: Before running this script, please make sure to:
REM 1. Checkout to the release_package branch: git checkout release_package
REM 2. Rebase with the latest changes: git rebase main
REM ========================================================================

cd /D "%~dp0"
@REM git clean -fdx
git submodule update --init --recursive

if not exist "envs" mkdir envs
if not exist "envs\miniconda3" mkdir envs\miniconda3

IF not EXIST %~dp0envs\miniconda3\Scripts (
    @RD /S /Q %~dp0envs\miniconda3
    mkdir %~dp0envs\miniconda3
    echo "Downloading miniconda..."
    powershell -Command "Invoke-WebRequest -Uri 'https://repo.anaconda.com/miniconda/Miniconda3-py310_24.9.2-0-Windows-x86_64.exe' -OutFile '.\envs\miniconda3.exe' -UseBasicParsing -Headers @{'User-Agent'='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36'}"

    echo "Installling minconda..."
    start /wait "" %~dp0envs\miniconda3.exe /S /AddToPath=0 /RegisterPython=0 /InstallationType=JustMe /D=%~dp0envs\miniconda3
    echo "Successfully install minconda"
    del envs\miniconda3.exe
)

SET PATH=%~dp0envs\miniconda3\Scripts;%PATH%

call activate
call conda env list
call conda update -y --all
call conda create -n ezvtb_rt_venv_release -c conda-forge conda-pack python=3.10 -y
call conda activate ezvtb_rt_venv_release
call conda env list

call conda install -y -c conda-forge cudatoolkit=12.9.1 cudnn=12.9.1
call conda install -y nvidia/label/cuda-12.9.1::cuda-nvcc-dev_win-64
call conda install -y pycuda -c https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/ 

call conda-pack -n ezvtb_rt_venv_release -o %~dp0envs\python_embedded --format no-archive


SET PATH=%~dp0envs\python_embedded;%~dp0envs\python_embedded\Scripts;%~dp0envs\python_embedded\Library\bin;%PATH%

call python -m pip install --upgrade pip wheel -i https://mirrors.aliyun.com/pypi/simple/
echo yes|python -m pip install nvidia-cudnn-cu12 -i https://mirrors.aliyun.com/pypi/simple/

echo yes|pip install tensorrt_cu12_libs==10.11.0.33 tensorrt_cu12_bindings==10.11.0.33 tensorrt==10.11.0.33 --extra-index-url https://pypi.nvidia.com

call python -m pip install -r requirements.txt --no-warn-script-location -i https://mirrors.aliyun.com/pypi/simple/

if not exist "data\models" mkdir data\models
echo "Downloading model zip file..."
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/zpeng11/ezvtuber-rt/releases/download/0.0.1/20241220.zip', '.\data\models\model.zip')"
echo "Unzipping model zip file..."
powershell -Command "Expand-Archive -Path '.\data\models\model.zip' -DestinationPath '.\data\models\temp' -Force; Move-Item -Path '.\data\models\temp\20241220\*' -Destination '.\data\models\' -Force; Remove-Item -Path '.\data\models\temp' -Recurse -Force"
del .\data\models\model.zip

@REM To verify if environment works
call python ezvtb_rt_interface.py 

@REM Clean up step
echo "Cleaning up .trt files in data\models directory..."
for /R %~dp0data\models %%f in (*.trt) do del "%%f"
@RD /S /Q %~dp0envs\miniconda3
pause