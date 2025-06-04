# ApoLoudness v0.3.5 Release Notes

Release Date: January 2025

## 🎉 Major Improvements

### 1. Enhanced Auto Offset Mode
- **Custom Reference Support**: Auto Offset now works with any reference level (75-90 dB), not just 80 dB
- **Smart Reference Management**: 
  - When Real SPL ≤ Reference: Maintains user-selected reference for tone balance improvement
  - When Real SPL > Reference: Automatically adjusts reference upward to preserve tone balance at high volumes
- **Example**: With Reference 75, you can enjoy improved tone balance for volumes up to 75 dB

### 2. Improved User Experience
- **Removed Middle Click Function**: Eliminated the "Reset Offset to 0" middle-click feature that caused sudden volume jumps
- **Cleaner Tooltip**: Simplified mouse control instructions

### 3. Code Quality Improvements
- **Complete Refactoring**: Entire codebase refactored for better maintainability
- **Magic Numbers Eliminated**: All hardcoded values replaced with named constants
- **Modular Design**: Complex logic split into focused helper methods
- **Improved Readability**: Cleaner, more understandable code structure

## 🐛 Bug Fixes
- Fixed Auto Offset behavior to respect user-selected reference levels
- Improved offset calculation accuracy

## 💡 How Auto Offset Works (Updated)

Auto Offset mode provides intelligent volume control based on Real SPL:

1. **Below Reference Level** (e.g., Real SPL ≤ 75 dB when Reference = 75):
   - Maintains your selected reference
   - Applies equal-loudness compensation for better tone balance at low volumes

2. **Above Reference Level** (e.g., Real SPL > 75 dB when Reference = 75):
   - Automatically increases reference to match Real SPL
   - Preserves original tone balance at higher volumes

This allows you to customize the transition point between tone-corrected and natural sound by selecting different reference levels.

## 🎮 Usage Tips

- **For Classical/Jazz**: Try Reference 75 for enhanced clarity at low volumes
- **For Rock/Pop**: Reference 80 works well for most scenarios
- **For Movies**: Reference 85-90 preserves dynamic range

## 🔧 Technical Details

### New Constants
- Window dimensions, font sizes, and UI elements
- SPL safety thresholds
- NIOSH hearing safety parameters
- Scroll increments and limits

### Refactored Methods
- `handleGlobalWheel()` - Simplified from 100+ lines to ~20 lines
- `updateConfig()` - Cleaner UI text generation
- `calculateSafeListeningTime()` - Uses named constants
- Multiple new helper methods for specific tasks

## 📋 System Requirements
- Windows 10/11
- Equalizer APO installed
- .NET Framework 4.7.2 or higher

## 🙏 Acknowledgments
Thanks to all users who provided feedback on the Auto Offset feature!