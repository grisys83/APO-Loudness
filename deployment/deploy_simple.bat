@echo off
echo Simple ApoLoudness Deployment Script
echo ====================================
echo.
echo This script copies executables for manual DLL deployment
echo.

set BUILD_DIR=..\build\Desktop_Qt_6_9_0_MinGW_64_bit-Release\release
set DEPLOY_DIR=ApoLoudness

echo Cleaning deployment directory...
rd /s /q %DEPLOY_DIR% 2>nul
mkdir %DEPLOY_DIR%

echo.
echo Copying executables...
copy "%BUILD_DIR%\ApoLoudness.exe" "%DEPLOY_DIR%\" 
if errorlevel 1 (
    echo ERROR: Failed to copy ApoLoudness.exe
    echo Make sure the file exists in: %BUILD_DIR%
    pause
    exit /b 1
)

copy "%BUILD_DIR%\ApoLoudnessCalibration.exe" "%DEPLOY_DIR%\"
if errorlevel 1 (
    echo ERROR: Failed to copy ApoLoudnessCalibration.exe
    pause
    exit /b 1
)

echo Copying configuration files...
copy "%BUILD_DIR%\calibration.ini" "%DEPLOY_DIR%\"

echo.
echo Creating DLL list for manual deployment...
(
echo Required Qt6 DLLs from C:\Qt\6.9.0\mingw_64\bin:
echo ================================================
echo Qt6Core.dll
echo Qt6Gui.dll
echo Qt6Widgets.dll
echo Qt6Multimedia.dll
echo Qt6Network.dll
echo.
echo Required MinGW DLLs from C:\Qt\Tools\mingw1310_64\bin:
echo ======================================================
echo libgcc_s_seh-1.dll
echo libstdc++-6.dll
echo libwinpthread-1.dll
echo.
echo Required Qt Plugins - Create these folders:
echo ==========================================
echo platforms\
echo   - qwindows.dll (from C:\Qt\6.9.0\mingw_64\plugins\platforms\)
echo.
echo styles\
echo   - qwindowsvistastyle.dll (from C:\Qt\6.9.0\mingw_64\plugins\styles\)
echo.
echo imageformats\
echo   - qico.dll (from C:\Qt\6.9.0\mingw_64\plugins\imageformats\)
echo.
echo multimedia\
echo   - windowsmediaplugin.dll (from C:\Qt\6.9.0\mingw_64\plugins\multimedia\)
echo   - ffmpegmediaplugin.dll (optional)
) > "%DEPLOY_DIR%\REQUIRED_DLLS.txt"

echo.
echo Creating README...
(
echo ApoLoudness v0.3.1
echo ==================
echo.
echo Installation:
echo 1. Copy all files and folders to your desired location
echo 2. Make sure all DLLs listed in REQUIRED_DLLS.txt are present
echo 3. Run ApoLoudness.exe
echo.
echo Requirements:
echo - Windows 10 or later ^(64-bit^)
echo - EqualizerAPO installed
echo.
echo Controls:
echo - Mouse Wheel: Adjust offset ^(manual^) or target ^(auto/calibration^)
echo - Ctrl + Wheel: Adjust target phon
echo - Right Click: Context menu
echo - Double Click: Reset ^(Target=Real=60dB with Auto Offset^)
echo - Right Mouse + Wheel: Global volume adjust ^(Auto Offset ON^)
echo.
echo Calibration:
echo Run ApoLoudnessCalibration.exe to calibrate your system
) > "%DEPLOY_DIR%\README.txt"

echo.
echo ============================================
echo Executables copied to: %DEPLOY_DIR%
echo.
echo IMPORTANT: You must manually copy the DLLs!
echo See %DEPLOY_DIR%\REQUIRED_DLLS.txt for the complete list
echo ============================================
echo.
pause