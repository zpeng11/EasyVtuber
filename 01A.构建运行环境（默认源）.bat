@echo on
@REM cd /D "%~dp0"
@REM if not exist "envs" mkdir envs
@REM if not exist "envs\miniconda3" mkdir envs\miniconda3

@REM echo "Downloading miniconda..."
@REM powershell -Command "(New-Object Net.WebClient).DownloadFile('https://repo.anaconda.com/miniconda/Miniconda3-py310_24.9.2-0-Windows-x86_64.exe', '.\envs\miniconda3.exe')"

@REM echo "Please ensure you did not install miniconda for current user, if so this will fail silencely, you will need to remove miniconda from you windows user folder to make this work again"
@REM echo "Installling minconda..."
@REM start /wait "" %~dp0envs\miniconda3.exe /S /AddToPath=0 /RegisterPython=0 /InstallationType=JustMe /D=%~dp0envs\miniconda3
@REM echo "Successfully install minconda"

@REM del envs\miniconda3.exe

call %~dp0envs\miniconda3\Scripts\activate.bat %~dp0envs\miniconda3
call %~dp0envs\miniconda3\condabin\conda activate base

call %~dp0envs\miniconda3\condabin\conda update conda -y
call %~dp0envs\miniconda3\condabin\conda install -y conda-forge::pycuda 
@REM onnx onnxruntime-directml turbojpeg tqdm opencv-python
@REM %~dp0envs\miniconda3\python.exe -m pip install --upgrade pip wheel
@REM %~dp0envs\miniconda3\python.exe -m pip install nvidia-cudnn-cu12
@REM %~dp0envs\miniconda3\Scripts\pip.exe install -r tensorrt_cu12_libs==10.6.0 tensorrt_cu12_bindings==10.6.0 tensorrt==10.6.0 --extra-index-url https://pypi.nvidia.com
pause