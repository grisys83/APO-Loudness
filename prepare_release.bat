@echo off
REM Prepare ApoLoudness v0.3.3 Release
REM This script prepares files for Inno Setup installer

echo ========================================
echo Preparing ApoLoudness v0.3.3 Release
echo ========================================

REM Set version
set VERSION=0.3.3

REM Create deployment directory structure
echo Creating deployment directories...
if not exist "deployment\ApoLoudness" mkdir "deployment\ApoLoudness"
if not exist "deployment\ApoLoudness\platforms" mkdir "deployment\ApoLoudness\platforms"
if not exist "deployment\ApoLoudness\imageformats" mkdir "deployment\ApoLoudness\imageformats"
if not exist "deployment\ApoLoudness\multimedia" mkdir "deployment\ApoLoudness\multimedia"
if not exist "deployment\filters\44100" mkdir "deployment\filters\44100"
if not exist "deployment\filters\48000" mkdir "deployment\filters\48000"

REM Copy executables (assumes Release build is complete)
echo Copying executables...
copy "build\Desktop_Qt_6_9_0_MinGW_64_bit-Release\release\ApoLoudness.exe" "deployment\ApoLoudness\" /Y
copy "build\Desktop_Qt_6_9_0_MinGW_64_bit-Release\release\ApoLoudnessCalibration.exe" "deployment\ApoLoudness\" /Y

REM Copy calibration.ini if exists
if exist "calibration.ini" (
    copy "calibration.ini" "deployment\ApoLoudness\" /Y
) else (
    echo Warning: calibration.ini not found, creating default...
    echo [General] > "deployment\ApoLoudness\calibration.ini"
    echo DeviceType=headphones >> "deployment\ApoLoudness\calibration.ini"
)

REM Deploy Qt dependencies (you need to adjust path to your Qt installation)
echo Deploying Qt dependencies...
set QT_BIN_PATH=D:\Qt\6.9.0\mingw_64\bin
if exist "%QT_BIN_PATH%\windeployqt.exe" (
    "%QT_BIN_PATH%\windeployqt.exe" --release --no-translations --no-system-d3d-compiler --no-opengl-sw "deployment\ApoLoudness\ApoLoudness.exe"
    "%QT_BIN_PATH%\windeployqt.exe" --release --no-translations --no-system-d3d-compiler --no-opengl-sw "deployment\ApoLoudness\ApoLoudnessCalibration.exe"
) else (
    echo ERROR: windeployqt.exe not found at %QT_BIN_PATH%
    echo Please adjust QT_BIN_PATH in this script
    pause
    exit /b 1
)

REM Copy README
echo Creating README.txt...
echo ApoLoudness v%VERSION% > "deployment\ApoLoudness\README.txt"
echo. >> "deployment\ApoLoudness\README.txt"
echo Equal-loudness volume control for EqualizerAPO >> "deployment\ApoLoudness\README.txt"
echo. >> "deployment\ApoLoudness\README.txt"
echo For detailed instructions, please see: >> "deployment\ApoLoudness\README.txt"
echo https://github.com/grisys83/APO-Loudness >> "deployment\ApoLoudness\README.txt"

REM Copy filter files (you need to generate these first with bulk_fir_filter_generator.py)
echo.
echo ========================================
echo IMPORTANT: Filter files preparation
echo ========================================
echo.
echo Please ensure you have generated filter files using:
echo   python bulk_fir_filter_generator.py
echo.
echo Filter files should be in:
echo   - Filters\44100\*.wav
echo   - Filters\48000\*.wav
echo.
echo Press any key to continue or Ctrl+C to abort...
pause > nul

if exist "Filters\44100\*.wav" (
    echo Copying 44.1kHz filters...
    xcopy "Filters\44100\*.wav" "deployment\filters\44100\" /Y /Q
) else (
    echo Warning: No 44.1kHz filter files found!
)

if exist "Filters\48000\*.wav" (
    echo Copying 48kHz filters...
    xcopy "Filters\48000\*.wav" "deployment\filters\48000\" /Y /Q
) else (
    echo Warning: No 48kHz filter files found!
)

echo.
echo ========================================
echo Release preparation complete!
echo ========================================
echo.
echo Next steps:
echo 1. Verify all files in deployment\ApoLoudness\
echo 2. Test executables run correctly
echo 3. Run Inno Setup with deployment\ApoLoudness_v033.iss
echo.
echo Installer will be created as:
echo   deployment\ApoLoudness_v%VERSION%_Setup.exe
echo.
pause