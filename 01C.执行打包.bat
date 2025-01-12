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
call conda create -y -n ezvtb_rt_venv python=3.10
call conda activate ezvtb_rt_venv
call conda env list

call conda install -y pycuda -c https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/ 

call conda install -y conda-pack -c https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/ 

call conda-pack -n ezvtb_rt_venv -o %~dp0envs\python_embedded.zip --format zip

call python -m pip wheel nvidia-cudnn-cu12 -i https://mirrors.aliyun.com/pypi/simple/ -w envs\wheels
call pip wheel tensorrt_cu12_libs==10.6.0 tensorrt_cu12_bindings==10.6.0 tensorrt==10.6.0 --extra-index-url https://pypi.nvidia.com -w envs\wheels
call python -m pip wheel -r requirements.txt -i https://mirrors.aliyun.com/pypi/simple/ -w envs\wheels

@REM Up to here you can use the envs\python_embedded.zip and envs\wheels to reconstruct a new environment
pause