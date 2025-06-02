# ApoLoudness Deployment Guide

## Overview
This guide explains how to deploy ApoLoudness for distribution to end users.

## Prerequisites
- Qt 6.9.0 with MinGW 64-bit compiler
- Windows 10 or later (for deployment tools)
- Inno Setup (optional, for creating installer)

## Deployment Methods

### Method 1: Automatic Deployment (Recommended)
1. Open Command Prompt in the `deployment` folder
2. Run `deploy.bat`
3. The script will:
   - Copy executables from the release build
   - Run `windeployqt` to copy Qt dependencies
   - Copy MinGW runtime libraries
   - Create README file

### Method 2: Manual Deployment
Follow the instructions in `deploy_manual.txt` if the automatic script fails.

### Method 3: Create Portable Package
1. First run `deploy.bat` to prepare files
2. Run `create_portable.bat` to create a ZIP file
3. Distribute the ZIP file to users

### Method 4: Create Installer
1. First run `deploy.bat` to prepare files
2. Install Inno Setup from https://jrsoftware.org/isinfo.php
3. Open `ApoLoudness.iss` in Inno Setup
4. Click "Compile" to create the installer

## Required Files
The deployment must include:

### Core Files
- `ApoLoudness.exe` - Main application
- `ApoLoudnessCalibration.exe` - Calibration helper
- `calibration.ini` - Default calibration data

### Qt6 Runtime Libraries
- `Qt6Core.dll` - Core Qt functionality
- `Qt6Gui.dll` - GUI framework
- `Qt6Widgets.dll` - Widget library
- `Qt6Multimedia.dll` - Audio support for calibration
- `Qt6Network.dll` - Network support (dependency)

### Qt6 Plugins
```
platforms/
  └── qwindows.dll          (Required)
  
styles/
  └── qwindowsvistastyle.dll (Recommended)
  
imageformats/
  ├── qico.dll              (Required for icons)
  └── qsvg.dll              (Optional)
  
multimedia/
  └── windowsmediaplugin.dll (Required for audio)
```

### MinGW Runtime
- `libgcc_s_seh-1.dll` - GCC runtime
- `libstdc++-6.dll` - C++ standard library
- `libwinpthread-1.dll` - Threading library

## Verification
Use `check_dependencies.ps1` to verify all dependencies:
```powershell
.\check_dependencies.ps1 -ExePath ".\ApoLoudness\ApoLoudness.exe"
```

## Testing
1. Copy the deployment folder to a clean Windows system
2. Ensure no Qt or MinGW is installed
3. Run both executables
4. Check for missing DLL errors

## Distribution Size
Typical deployment size:
- Portable ZIP: ~30-40 MB
- Installer: ~25-35 MB (compressed)

## Troubleshooting

### Missing DLL Errors
- Use Dependency Walker or Dependencies.exe
- Check the Qt plugins directory structure
- Verify MinGW runtime DLLs are included

### Audio Issues in Calibration Tool
- Ensure multimedia plugins are included
- Check `Qt6Multimedia.dll` is present
- Verify `windowsmediaplugin.dll` in multimedia folder

### Visual Style Issues
- Include `qwindowsvistastyle.dll` in styles folder
- Check that platforms folder contains `qwindows.dll`

## Notes
- The global mouse hook feature requires Windows
- EqualizerAPO must be installed separately
- Configuration is saved to `C:\Program Files\EqualizerAPO\config\Loudness.txt`