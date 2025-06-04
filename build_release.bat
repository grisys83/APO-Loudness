@echo off
echo ========================================
echo ApoLoudness v0.3.5 Release Build Script
echo ========================================
echo.

REM Check if Qt is in PATH
where qmake >nul 2>nul
if %errorlevel% neq 0 (
    echo ERROR: qmake not found in PATH!
    echo Please ensure Qt is installed and added to PATH
    echo Example: D:\Qt\5.15.2\msvc2019_64\bin
    pause
    exit /b 1
)

REM Clean previous builds
echo Cleaning previous builds...
if exist release rmdir /s /q release
if exist debug rmdir /s /q debug
if exist Makefile del Makefile
if exist Makefile.Release del Makefile.Release
if exist Makefile.Debug del Makefile.Debug

REM Build ApoLoudness
echo.
echo Building ApoLoudness...
qmake ApoLoudness.pro -spec win32-g++ CONFIG+=release
if %errorlevel% neq 0 (
    echo ERROR: qmake failed for ApoLoudness!
    pause
    exit /b 1
)

mingw32-make release
if %errorlevel% neq 0 (
    echo ERROR: Build failed for ApoLoudness!
    pause
    exit /b 1
)

REM Build ApoLoudnessCalibration
echo.
echo Building ApoLoudnessCalibration...
qmake ApoLoudnessCalibration.pro -spec win32-g++ CONFIG+=release
if %errorlevel% neq 0 (
    echo ERROR: qmake failed for ApoLoudnessCalibration!
    pause
    exit /b 1
)

mingw32-make release
if %errorlevel% neq 0 (
    echo ERROR: Build failed for ApoLoudnessCalibration!
    pause
    exit /b 1
)

echo.
echo ========================================
echo Build completed successfully!
echo ========================================
echo.
echo Release files:
echo - release\ApoLoudness.exe
echo - release\ApoLoudnessCalibration.exe
echo.
pause