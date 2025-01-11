@echo off

WHERE nvidia-smi
IF %ERRORLEVEL% NEQ 0 (
    echo 'CudaTookit No Ready!!!! Please install manually'
) else (
    echo 'CudaTookit Ready, go ahead next step'
)
echo.
echo.
echo Make sure everything is OK before you run 01A or 01B.
pause