# ApoLoudness v0.3.5

## 🎉 Major Improvements

### Enhanced Auto Offset Mode
The star feature of this release! Auto Offset now works intelligently with ANY reference level you choose (75-90 dB), not just 80 dB.

- **Custom Reference Support**: Choose your preferred reference level with Alt+Wheel
- **Smart Volume Control**: Maintains your chosen reference for tone balance until Real SPL exceeds it
- **Intelligent Reference Management**: Automatically adjusts reference upward only when needed

### Example Use Cases:
- 🎼 **Classical/Jazz lovers**: Set Reference to 75-78 for enhanced detail at low volumes
- 🎸 **Rock/Pop listeners**: Use Reference 78-82 for balanced tone across volumes  
- 🎬 **Movie watchers**: Try Reference 82-85 to preserve dynamic range

## 🐛 Bug Fixes & Improvements

- **Removed Middle Click Reset**: Eliminated the sudden volume jump issue
- **Complete Code Refactoring**: Cleaner, more maintainable codebase
- **UI Polish**: Compact display with color-coded safety indicators
- **Build System**: Added comprehensive build and deployment scripts

## 📥 Downloads

### Installer (Recommended)
**[ApoLoudness_v0.3.5_Setup.exe](https://github.com/grisys83/APO-Loudness/releases/download/v0.3.5/ApoLoudness_v0.3.5_Setup.exe)**
- Automatic Equalizer APO integration
- Sample rate detection (44.1/48 kHz)
- Includes all dependencies

### Portable Version
**[ApoLoudness_v0.3.5_Portable.zip](https://github.com/grisys83/APO-Loudness/releases/download/v0.3.5/ApoLoudness_v0.3.5_Portable.zip)**
- No installation required
- Manual Equalizer APO configuration needed

## 📋 What's Changed

### Features
- Enhanced Auto Offset mode with flexible reference selection
- Real SPL-based volume control improvements
- Safety listening time display with NIOSH standards
- 5-tier color coding for SPL safety levels

### Technical
- All magic numbers replaced with named constants
- Complex logic split into focused helper methods
- Improved error handling and edge cases
- Extended offset range to ±30 dB

### Documentation
- Comprehensive README with v0.3.5 features
- Detailed release notes
- Quick reference guide (README.txt)

## 🔧 Installation

1. Ensure [Equalizer APO](https://sourceforge.net/projects/equalizerapo/) is installed
2. Run the installer and follow prompts
3. Perform calibration (see README for details)
4. Enjoy perfect tonal balance at any volume!

## 💡 Quick Tip

After installation, try different reference levels to find your sweet spot:
- Late night: Reference 75 + Auto Offset
- Normal listening: Reference 80 + Auto Offset  
- Loud sessions: Reference 85 + Auto Offset

## 🙏 Acknowledgments

Thanks to all users who provided feedback on the Auto Offset feature. Your input made this release possible!

---

**Full Changelog**: https://github.com/grisys83/APO-Loudness/compare/v0.3.3...v0.3.5