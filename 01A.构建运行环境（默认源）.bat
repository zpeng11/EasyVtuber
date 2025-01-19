@echo on
cd /D "%~dp0"

WHERE conda
IF %ERRORLEVEL% NEQ 0 (
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
)

IF EXIST %~dp0envs\miniconda3\Scripts SET PATH=%~dp0envs\miniconda3\Scripts;%PATH%

call activate
call conda env list
call conda update -y --all
call conda create -y -n quantization python=3.10
call conda activate quantization
call conda env list


call python -m pip install --upgrade pip wheel
call python -m pip install -r requirements.txt --no-warn-script-location

pause