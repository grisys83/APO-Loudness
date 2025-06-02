@echo off
echo ApoLoudness Complete Deployment Script
echo ======================================
echo.

:: Run the simple deployment first
echo Step 1: Copying executables...
call deploy_simple.bat
if errorlevel 1 exit /b 1

echo.
echo Step 2: Copying DLL files...
echo.

:: Check if PowerShell is available
powershell -Command "Write-Host 'PowerShell is available' -ForegroundColor Green" >nul 2>&1
if errorlevel 1 (
    echo ERROR: PowerShell is not available
    echo Please copy DLLs manually according to REQUIRED_DLLS.txt
    pause
    exit /b 1
)

:: Run PowerShell script to copy DLLs
echo Running DLL copy script...
powershell -ExecutionPolicy Bypass -File copy_dlls.ps1

echo.
echo Step 3: Creating portable package...
call create_portable.bat

echo.
echo ======================================
echo Deployment Summary:
echo ======================================
echo 1. Executables copied to: ApoLoudness\
echo 2. DLLs should be copied (check for errors above)
echo 3. Portable ZIP created (if successful)
echo.
echo If any step failed, please:
echo - Check Qt installation paths in copy_dlls.ps1
echo - Manually copy DLLs according to ApoLoudness\REQUIRED_DLLS.txt
echo - Run create_portable.bat after all files are ready
echo ======================================
pause