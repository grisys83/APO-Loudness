@echo off
echo ============================================
echo ApoLoudness v0.3.5 Deployment Preparation
echo ============================================
echo.

REM Set version
set VERSION=0.3.5

REM Create deployment directory structure
echo Creating deployment directory structure...
if not exist deployment mkdir deployment
if not exist deployment\ApoLoudness mkdir deployment\ApoLoudness

REM Check if release executables exist
if not exist release\ApoLoudness.exe (
    echo ERROR: release\ApoLoudness.exe not found!
    echo Please run build_release.bat first.
    pause
    exit /b 1
)

if not exist release\ApoLoudnessCalibration.exe (
    echo ERROR: release\ApoLoudnessCalibration.exe not found!
    echo Please run build_release.bat first.
    pause
    exit /b 1
)

REM Copy executables
echo.
echo Copying executables...
copy /Y release\ApoLoudness.exe deployment\ApoLoudness\
copy /Y release\ApoLoudnessCalibration.exe deployment\ApoLoudness\

REM Deploy Qt dependencies
echo.
echo Deploying Qt dependencies...
cd deployment\ApoLoudness
windeployqt --release --no-translations --no-system-d3d-compiler --no-opengl-sw ApoLoudness.exe
windeployqt --release --no-translations --no-system-d3d-compiler --no-opengl-sw ApoLoudnessCalibration.exe
cd ..\..

REM Copy documentation
echo.
echo Copying documentation...
copy /Y README.txt deployment\ApoLoudness\
copy /Y RELEASE_NOTES_v%VERSION%.md deployment\ApoLoudness\

REM Copy calibration files
echo.
echo Copying calibration files...
if exist calibration.ini copy /Y calibration.ini deployment\ApoLoudness\

REM Create portable zip
echo.
echo Creating portable ZIP package...
cd deployment
"C:\Program Files\7-Zip\7z.exe" a -tzip ApoLoudness_v%VERSION%_Portable.zip ApoLoudness\*
if %errorlevel% neq 0 (
    echo WARNING: 7-Zip not found or failed. Please create ZIP manually.
)
cd ..

echo.
echo ============================================
echo Deployment preparation completed!
echo ============================================
echo.
echo Files ready in: deployment\ApoLoudness\
echo Portable ZIP: deployment\ApoLoudness_v%VERSION%_Portable.zip
echo.
echo Next steps:
echo 1. Test the executables in deployment\ApoLoudness\
echo 2. Create installer using: iscc deployment\ApoLoudness_v035.iss
echo 3. Upload to GitHub releases
echo.
pause