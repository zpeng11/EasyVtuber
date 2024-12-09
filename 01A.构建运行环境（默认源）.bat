@echo on
cd /D "%~dp0"
if not exist "envs" mkdir envs
if not exist "envs\miniconda3" mkdir envs\miniconda3

echo "Downloading miniconda..."
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://repo.anaconda.com/miniconda/Miniconda3-py310_24.9.2-0-Windows-x86_64.exe', '.\envs\miniconda3.exe')"

echo "Please ensure you did not install miniconda for current user, if so this will fail silencely, you will need to remove miniconda from you windows user folder to make this work again"
echo "Installling minconda..."
start /wait "" %~dp0envs\miniconda3.exe /S /AddToPath=0 /RegisterPython=0 /InstallationType=JustMe /D=%~dp0envs\miniconda3
echo "Successfully install minconda"

del envs\miniconda3.exe

call %~dp0envs\miniconda3\Scripts\activate.bat %~dp0envs\miniconda3
call %~dp0envs\miniconda3\condabin\conda update -y --all
call %~dp0envs\miniconda3\condabin\conda create -y -n ezvtb_rt_venv python=3.10
call %~dp0envs\miniconda3\condabin\conda activate ezvtb_rt_venv
call %~dp0envs\miniconda3\condabin\conda env list

call %~dp0envs\miniconda3\condabin\conda update conda -y
call %~dp0envs\miniconda3\condabin\conda install -y conda-forge::pycuda 

call %~dp0envs\miniconda3\python.exe -m pip install --upgrade pip wheel
echo yes|%~dp0envs\miniconda3\python.exe -m pip install nvidia-cudnn-cu12

echo yes|%~dp0envs\miniconda3\Scripts\pip.exe install tensorrt_cu12_libs==10.6.0 tensorrt_cu12_bindings==10.6.0 tensorrt==10.6.0 --extra-index-url https://pypi.nvidia.com

call %~dp0envs\miniconda3\python.exe -m pip install -r requirements.txt --no-warn-script-location
pause