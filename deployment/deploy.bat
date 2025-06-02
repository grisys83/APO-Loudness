@echo off
echo ApoLoudness Deployment Script
echo ============================

set QT_DIR=D:\Qt\6.9.0\mingw_64
set MINGW_DIR=D:\Qt\Tools\mingw1310_64
set BUILD_DIR=..\build\Desktop_Qt_6_9_0_MinGW_64_bit-Release\release
set DEPLOY_DIR=ApoLoudness

echo Cleaning deployment directory...
rd /s /q %DEPLOY_DIR% 2>nul
mkdir %DEPLOY_DIR%

echo Copying executables...
copy "%BUILD_DIR%\ApoLoudness.exe" "%DEPLOY_DIR%\" || goto :error
copy "%BUILD_DIR%\ApoLoudnessCalibration.exe" "%DEPLOY_DIR%\" || goto :error

echo Copying configuration files...
copy "%BUILD_DIR%\calibration.ini" "%DEPLOY_DIR%\" || goto :error

echo Deploying Qt dependencies...
%QT_DIR%\bin\windeployqt.exe --release --no-translations --no-system-d3d-compiler --no-opengl-sw "%DEPLOY_DIR%\ApoLoudness.exe" || goto :error
%QT_DIR%\bin\windeployqt.exe --release --no-translations --no-system-d3d-compiler --no-opengl-sw "%DEPLOY_DIR%\ApoLoudnessCalibration.exe" || goto :error

echo Copying MinGW runtime libraries...
copy "%MINGW_DIR%\bin\libgcc_s_seh-1.dll" "%DEPLOY_DIR%\" || goto :error
copy "%MINGW_DIR%\bin\libstdc++-6.dll" "%DEPLOY_DIR%\" || goto :error
copy "%MINGW_DIR%\bin\libwinpthread-1.dll" "%DEPLOY_DIR%\" || goto :error

echo Creating README...
echo ApoLoudness v0.3.1 > "%DEPLOY_DIR%\README.txt"
echo ================== >> "%DEPLOY_DIR%\README.txt"
echo. >> "%DEPLOY_DIR%\README.txt"
echo Installation: >> "%DEPLOY_DIR%\README.txt"
echo 1. Copy all files to a folder of your choice >> "%DEPLOY_DIR%\README.txt"
echo 2. Run ApoLoudness.exe >> "%DEPLOY_DIR%\README.txt"
echo 3. For calibration, run ApoLoudnessCalibration.exe >> "%DEPLOY_DIR%\README.txt"
echo. >> "%DEPLOY_DIR%\README.txt"
echo Requirements: >> "%DEPLOY_DIR%\README.txt"
echo - Windows 10 or later (64-bit) >> "%DEPLOY_DIR%\README.txt"
echo - EqualizerAPO installed >> "%DEPLOY_DIR%\README.txt"
echo. >> "%DEPLOY_DIR%\README.txt"
echo Controls: >> "%DEPLOY_DIR%\README.txt"
echo - Mouse Wheel: Adjust offset (manual mode) or target (auto/calibration mode) >> "%DEPLOY_DIR%\README.txt"
echo - Ctrl + Wheel: Adjust target phon >> "%DEPLOY_DIR%\README.txt"
echo - Right Click: Context menu >> "%DEPLOY_DIR%\README.txt"
echo - Double Click: Reset to default (Target=Real=60dB with Auto Offset) >> "%DEPLOY_DIR%\README.txt"
echo - Right Mouse + Wheel (anywhere): Adjust volume when Auto Offset is ON >> "%DEPLOY_DIR%\README.txt"

echo.
echo Deployment completed successfully!
echo Files are in: %DEPLOY_DIR%
goto :end

:error
echo.
echo ERROR: Deployment failed!
exit /b 1

:end
pause