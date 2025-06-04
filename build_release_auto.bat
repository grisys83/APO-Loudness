@echo off
echo ========================================
echo ApoLoudness v0.3.5 Release Build Script
echo (Auto-detecting compiler)
echo ========================================
echo.

REM Check if Qt is in PATH
where qmake >nul 2>nul
if %errorlevel% neq 0 (
    echo ERROR: qmake not found in PATH!
    echo Please ensure Qt is installed and added to PATH
    echo Example: D:\Qt\5.15.2\mingw81_64\bin
    pause
    exit /b 1
)

REM Detect compiler
set COMPILER_SPEC=
set MAKE_TOOL=

REM Check for MinGW
where mingw32-make >nul 2>nul
if %errorlevel% equ 0 (
    echo Found MinGW compiler
    set COMPILER_SPEC=win32-g++
    set MAKE_TOOL=mingw32-make
    goto :compiler_found
)

REM Check for MSVC
where cl >nul 2>nul
if %errorlevel% equ 0 (
    echo Found MSVC compiler
    set COMPILER_SPEC=win32-msvc
    set MAKE_TOOL=nmake
    goto :compiler_found
)

echo ERROR: No compiler found!
echo Please install MinGW or Visual Studio
pause
exit /b 1

:compiler_found

REM Clean previous builds
echo.
echo Cleaning previous builds...
if exist release rmdir /s /q release
if exist debug rmdir /s /q debug
if exist Makefile del Makefile
if exist Makefile.Release del Makefile.Release
if exist Makefile.Debug del Makefile.Debug
if exist object_script.*.Release del object_script.*.Release
if exist object_script.*.Debug del object_script.*.Debug

REM Build ApoLoudness
echo.
echo Building ApoLoudness with %COMPILER_SPEC%...
qmake ApoLoudness.pro -spec %COMPILER_SPEC% CONFIG+=release
if %errorlevel% neq 0 (
    echo ERROR: qmake failed for ApoLoudness!
    pause
    exit /b 1
)

%MAKE_TOOL% release
if %errorlevel% neq 0 (
    echo ERROR: Build failed for ApoLoudness!
    pause
    exit /b 1
)

REM Build ApoLoudnessCalibration
echo.
echo Building ApoLoudnessCalibration with %COMPILER_SPEC%...
qmake ApoLoudnessCalibration.pro -spec %COMPILER_SPEC% CONFIG+=release
if %errorlevel% neq 0 (
    echo ERROR: qmake failed for ApoLoudnessCalibration!
    pause
    exit /b 1
)

%MAKE_TOOL% release
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
echo Compiler used: %COMPILER_SPEC%
echo Make tool: %MAKE_TOOL%
echo.
echo Release files:
echo - release\ApoLoudness.exe
echo - release\ApoLoudnessCalibration.exe
echo.
pause