# ApoLoudness v0.3.3 Release Checklist

## Pre-Release Tasks

### Code Preparation
- [x] Fix Convolution path to use "../Filters/"
- [x] Fix Real SPL calculation when Target equals Reference
- [x] Implement Auto Offset wheel accumulator improvements
- [x] Fix mouse hook interference with browser scrolling
- [x] Remove debug console
- [x] Fix Calibration mode to start with Reference 80
- [x] Remove Reference Level Selection UI
- [x] Add calibration backup with timestamp
- [x] Add missing #include <QFile> in calibrationhelper.cpp
- [x] Remove unused currentRealSPL variable

### Documentation
- [x] Update README.md with v0.3.3 changes
- [x] Create README files for Python scripts
- [x] Update version numbers in documentation
- [x] Document new backup functionality

### Build Preparation
- [x] Update Inno Setup script to v0.3.3
- [x] Create deployment scripts (batch, PowerShell, Makefile)
- [x] Prepare release checklist

## Build Process

### 1. Generate Filter Files
```bash
python bulk_fir_filter_generator.py
```
This creates filter files in:
- Filters/44100/*.wav
- Filters/48000/*.wav

### 2. Build Release Binaries
Using Qt Creator:
1. Open ApoLoudness.pro
2. Select Release configuration
3. Build → Build All
4. Repeat for ApoLoudnessCalibration.pro

Or using command line:
```bash
qmake ApoLoudness.pro -spec win32-g++ CONFIG+=release
mingw32-make
qmake ApoLoudnessCalibration.pro -spec win32-g++ CONFIG+=release
mingw32-make
```

### 3. Prepare Deployment
Run one of the deployment scripts:

**Option A - Batch Script:**
```cmd
prepare_release.bat
```

**Option B - PowerShell:**
```powershell
.\Deploy-Release.ps1 -Version "0.3.3"
```

**Option C - Makefile:**
```bash
make -f Makefile.release all
```

### 4. Test Deployment
- [ ] Test ApoLoudness.exe runs without errors
- [ ] Test ApoLoudnessCalibration.exe runs without errors
- [ ] Verify all Qt dependencies are included
- [ ] Test on a clean system without Qt installed

### 5. Build Installer
1. Open `deployment\ApoLoudness_v033.iss` in Inno Setup
2. Compile (Ctrl+F9)
3. Output: `deployment\ApoLoudness_v0.3.3_Setup.exe`

## Release Tasks

### 1. Final Testing
- [ ] Install on clean Windows system
- [ ] Verify EqualizerAPO integration
- [ ] Test calibration process
- [ ] Test all mouse controls
- [ ] Verify filter path resolution

### 2. GitHub Release
1. Create new release tag: `v0.3.3`
2. Upload `ApoLoudness_v0.3.3_Setup.exe`
3. Add release notes from README version history
4. Publish release

### 3. Post-Release
- [ ] Update project website/wiki if applicable
- [ ] Announce release in relevant forums
- [ ] Monitor for user feedback

## Known Issues to Document
- Requires EqualizerAPO to be installed first
- Windows-only (uses Windows audio APIs)
- Requires administrator privileges for installation

## Files Included in Release
- ApoLoudness.exe
- ApoLoudnessCalibration.exe
- calibration.ini (default)
- Qt6 runtime DLLs
- MinGW runtime DLLs
- Qt plugins (platforms, imageformats, multimedia)
- Filter files (44100Hz and 48000Hz)
- README.txt