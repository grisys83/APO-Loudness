@echo off
echo Creating Portable ApoLoudness Package
echo =====================================

set DEPLOY_DIR=ApoLoudness
set ZIP_NAME=ApoLoudness_v0.3.1_Portable.zip

echo.
echo Checking if deployment directory exists...
if not exist "%DEPLOY_DIR%" (
    echo ERROR: Deployment directory not found!
    echo Please run deploy.bat first.
    pause
    exit /b 1
)

echo.
echo Creating portable package...

:: Use PowerShell to create ZIP (works on Windows 10+)
powershell -Command "Compress-Archive -Path '%DEPLOY_DIR%\*' -DestinationPath '%ZIP_NAME%' -Force"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo Success! Portable package created: %ZIP_NAME%
    echo.
    echo Package contents:
    echo - ApoLoudness.exe (Main application)
    echo - ApoLoudnessCalibration.exe (Calibration helper)
    echo - All required Qt6 and MinGW DLLs
    echo - Configuration files
    echo.
    echo To use:
    echo 1. Extract the ZIP file to any location
    echo 2. Run ApoLoudness.exe
    echo.
) else (
    echo.
    echo ERROR: Failed to create ZIP file!
    echo You can manually ZIP the %DEPLOY_DIR% folder.
)

pause