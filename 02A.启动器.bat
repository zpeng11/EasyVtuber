@echo on
cd /D "%~dp0"

SET PATH=%~dp0envs\python_embedded;%~dp0envs\python_embedded\Scripts;%PATH%

IF not EXIST %~dp0launcher.json (
    call pip install --no-index --find-links %~dp0envs\wheels  -r requirements-pack.txt 
    call python ezvtb_rt_interface.py
)

pythonw launcher2.py