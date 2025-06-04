@echo off
echo ================================================
echo ApoLoudness v0.3.5 Full Release Process
echo ================================================
echo.
echo This script will:
echo 1. Build release versions
echo 2. Prepare deployment files
echo 3. Create installer (if Inno Setup is installed)
echo.
pause

REM Step 1: Build
echo.
echo Step 1: Building release versions...
call build_release.bat
if %errorlevel% neq 0 (
    echo Build failed! Aborting.
    pause
    exit /b 1
)

REM Step 2: Prepare deployment
echo.
echo Step 2: Preparing deployment...
call prepare_deployment.bat
if %errorlevel% neq 0 (
    echo Deployment preparation failed! Aborting.
    pause
    exit /b 1
)

REM Step 3: Create installer
echo.
echo Step 3: Creating installer...
if exist "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" (
    "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" deployment\ApoLoudness_v035.iss
) else if exist "C:\Program Files\Inno Setup 6\ISCC.exe" (
    "C:\Program Files\Inno Setup 6\ISCC.exe" deployment\ApoLoudness_v035.iss
) else (
    echo WARNING: Inno Setup not found!
    echo Please install Inno Setup 6 or create installer manually.
    echo Run: iscc deployment\ApoLoudness_v035.iss
)

echo.
echo ================================================
echo Release process completed!
echo ================================================
echo.
echo Release artifacts:
echo - Portable: deployment\ApoLoudness_v0.3.5_Portable.zip
echo - Installer: deployment\ApoLoudness_v0.3.5_Setup.exe
echo.
echo Next steps:
echo 1. Test both portable and installer versions
echo 2. Create git tag: git tag v0.3.5
echo 3. Push to GitHub: git push origin v0.3.5
echo 4. Create GitHub release and upload artifacts
echo.
pause