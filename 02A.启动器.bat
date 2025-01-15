@echo on
cd /D "%~dp0"

SET PATH=%~dp0envs\python_embedded;%~dp0envs\python_embedded\Scripts;%~dp0envs\python_embedded\Library\bin;%PATH%

pythonw launcher2.py