# ApoLoudness v0.3.3 Release Notes

## What's New

This release includes several important bug fixes and improvements to enhance the user experience.

## Changes

### 🐛 Bug Fixes
- **Fixed Convolution Path**: Now correctly uses "../Filters/" for proper relative path resolution
- **Real SPL Calculation**: Fixed calculation error when Target equals Reference value
- **Mouse Hook**: Fixed interference with browser scrolling - the global hook now only captures events when appropriate
- **Calibration Mode**: Now correctly starts with Reference 80 (previously started at 82)

### ✨ Improvements
- **Auto Offset Mode**: Enhanced wheel accumulator logic for better volume control
- **UI Cleanup**: Removed unused Reference Level Selection menu (use Alt+Wheel instead)
- **Calibration Backup**: Previous calibration measurements are now automatically backed up with timestamp
- **Debug Console**: Removed debug console window for cleaner operation
- **Code Quality**: Removed unused variables and improved overall efficiency

### 📝 Documentation
- Updated all tooltips and info dialogs to English
- Improved mouse control documentation in README
- Added comprehensive documentation for Python utility scripts

## Installation

1. Download `ApoLoudness_v0.3.3_Setup.exe`
2. Ensure EqualizerAPO is installed first
3. Run the installer and follow the prompts
4. Use ApoLoudnessCalibration.exe for initial setup
5. Run ApoLoudness.exe for daily use

## System Requirements

- Windows 10/11 (64-bit)
- EqualizerAPO installed
- Administrator privileges for installation

## Known Issues

- Requires EqualizerAPO to be installed before ApoLoudness
- Windows-only application

## SHA256 Checksum

[To be added after build]

---

For detailed usage instructions, please refer to the [README](https://github.com/grisys83/APO-Loudness/blob/main/README.md).