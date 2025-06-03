# ApoLoudness User Manual v0.3.3

## 🎵 What is ApoLoudness?

**"An innovative audio tool that maintains tonal balance regardless of volume changes"**

ApoLoudness is a program that maintains the same tonal balance as 80dB even at low volumes. This allows you to enjoy rich bass and natural timbre while protecting your hearing.

## 🔬 How It Works (Simple Explanation)

Human ears have different frequency sensitivities depending on volume. At quiet levels, bass and treble are relatively harder to hear. ApoLoudness precisely corrects this based on equal-loudness contours.

- **Traditional volume control**: All frequencies ↑↓ equally → Tonal balance changes
- **ApoLoudness**: Custom adjustment per frequency ↕️ → Tonal balance maintained ✨

## 📥 Download and Installation

### Download Links

- **Windows Installer**: [ApoLoudness_v0.3.3_Setup.exe](https://github.com/grisys83/APO-Loudness/releases/download/v0.3.3/ApoLoudness_v0.3.3_Setup.exe)
- Includes automatic sample rate detection (44.1kHz/48.0kHz)

### ⚠️ Important Legal Notice

- By installing this software, you agree to the GPLv3 license
- All usage responsibility lies with the user
- The installer requires Administrator privileges

### Installation Steps

#### Step 1: Install ApoLoudness
1. Download and run `ApoLoudness_v0.3.3_Setup.exe`
2. The installer will detect your audio device's sample rate
3. Confirm or change the sample rate (44.1kHz or 48.0kHz)
4. Installation path: `C:\Program Files\EqualizerAPO\config\ApoLoudness\`

#### Step 2: Verify Installation
The installer automatically:
- Copies program files to EqualizerAPO config folder
- Installs appropriate filter files (44.1kHz or 48.0kHz)
- Updates EqualizerAPO's config.txt with `Include: ApoLoudness\ApoLoudness.txt`
- Creates shortcuts in Start Menu and Desktop (optional)

#### Step 3: First Run
1. Launch ApoLoudness from Start Menu or Desktop shortcut
2. Launch ApoLoudnessCalibration for initial setup
3. Follow the calibration process below

## 🎯 Calibration (Required Once)

### Required Equipment

- Smartphone (with SPL meter app installed)
- Headphones or speakers
- Quiet environment (minimize background noise)

### Recommended SPL Meter Apps

- **iOS**: NIOSH Sound Level Meter
- **Android**: Decibel X (dBA, dBC)
- **Measurement mode**: Z-weighting recommended (C-weighting is OK if unavailable)

### Calibration Process

#### Understanding Calibration

ApoLoudness now uses advanced (Reference, Target) pair calibration for more accurate Real SPL estimation. However, you don't need to measure all 21 combinations - the system can intelligently interpolate missing values.

#### Step 1: Launch Programs

1. Run `ApoLoudnessCalibration.exe`
2. Run `ApoLoudness.exe`
3. In ApoLoudness, right-click → Check "Calibration Mode"

#### Step 2: Set Reference Point (80dB)

⚠️ **Very Important Preparation**:
- Windows volume: Set to 100%
- Amp volume: Set slightly lower than usual
- 0dB pink noise will be played!

1. Place phone microphone inside headphone ear cup
2. Click "Pink Noise" play button in Calibration program
3. Adjust amp volume until SPL meter shows exactly 80dB
4. Enter 80 in "Measured SPL" and click Next

#### Step 3: Measurement Process

**Simplified Approach (Recommended for most users):**
- Measure Reference 80 with Targets: 40, 50, 60, 70, 80
- This covers the most common usage scenarios
- Other combinations will be intelligently estimated

**Comprehensive Approach (For advanced users):**
The system supports measuring all combinations:
- **Reference 90:** Targets 40, 50, 60, 70, 80, 90
- **Reference 80:** Targets 40, 50, 60, 70, 80  
- **Reference 70:** Targets 40, 50, 60, 70
- **Reference 60:** Targets 40, 50, 60
- **Reference 50:** Targets 40, 50
- **Reference 40:** Target 40

Process:
1. In Calibration Mode, preamp uses exact map values (no offset)
2. Use Alt + Wheel to set Reference level
3. Use Wheel to adjust Target in 10dB steps
4. Click "Play Test Tone" and measure SPL
5. Enter reading and click Next
6. The system saves as (Reference, Target) pairs for accurate lookup

#### Step 4: Save

- After all measurements complete, click "Save Calibration"
- If failed, restart programs and try again

### 💡 Calibration Tips

- If "Play Test Tone" is disabled, press Stop button to re-enable
- If measurements seem off, check background noise or microphone position
- Recommend measuring multiple times for consistent values

## 🚀 How to Use

### 🖱️ Mouse Controls (Complete Guide)

#### When Mouse is Over Program Window:
- **Mouse Wheel**: Adjust based on current mode
  - Manual Mode: Offset adjustment (-20 to 0dB)
  - Auto Offset Mode: Real SPL based volume control
  - Calibration Mode: Target adjustment in 10dB steps
- **Ctrl + Wheel**: Target Phon adjustment (1dB steps)
- **Alt + Wheel**: Reference Phon adjustment (75-90dB range)
- **Middle Click**: Reset Offset to 0
- **Double Click**: Reset all to defaults (Target=60, Reference=80, Auto Offset ON)
- **Right Click**: Open context menu

#### Global Control (Works Anywhere):
- **Right Mouse Button + Wheel**: Automatically activates Auto Offset mode and adjusts volume
  - Works even when mouse is outside the program window
  - Perfect for quick volume adjustments while using other applications

### Auto Offset Mode (Recommended)

After calibration is complete, turning on Auto Offset lets you experience the true value of ApoLoudness.

**Auto Offset Features**:
- Real SPL based volume control
- Automatic tonal balance optimization
- Smart Target/Reference adjustment:
  - Wheel up normally: Increases Target up to Reference
  - Wheel up "a lot" (10+ times): Increases both Target and Reference by 1
  - Wheel down: Decreases Target, and Reference follows when Target < 80

**How to Use**:
1. Right-click → Check "Auto Offset" OR use Right Mouse + Wheel anywhere
2. Adjust volume with scroll wheel for Real SPL based control
3. Double-click to reset to defaults

### Manual Mode (Advanced Users)

Use when you want fine manual adjustments with Auto Offset off.

**Controls**:
- **Scroll wheel**: Adjust Offset (traditional volume control)
- **Ctrl + wheel**: Adjust Target (desired loudness level)
- **Alt + wheel**: Adjust Reference (75-90dB range)
- Real SPL cannot exceed Target (automatic limiting)

## 🎛️ Interface Description

### Main Screen
```
Target: 60.0  Reference: 80.0  Offset: +1.0
Preamp: -15.6 dB  Real: 60.3 dB SPL
```

**Parameter Meanings**:
- **Target**: Desired volume level (40-80dB)
- **Reference**: Reference volume level (typically fixed at 80dB)
- **Offset**: User fine-tuning value (-20dB to +10dB)
- **Preamp**: Final gain applied to Equalizer APO
- **Real**: Actual measured sound pressure level (based on calibration)

### Context Menu (Right-click)

- **Always on Top**: Keep window on top
- **Auto Offset**: Automatic optimization mode
- **Calibration Mode**: Calibration mode
- **Info**: Current settings and help
- **Exit**: Exit program

## 🔧 Troubleshooting (FAQ)

**Q1: When Real value differs significantly from Target**
A: Re-perform calibration or adjust Offset in Manual mode.

**Q2: When sound is too quiet or loud**
A:
- Adjust with scroll wheel in Auto Offset mode
- Adjust Offset value in Manual mode
- Check amp or system volume

**Q3: When tonal balance seems off**
A:
- Ensure Target doesn't exceed Reference (Target ≤ Reference)
- Re-check calibration measurements
- Double-click to restore defaults and retry

**Q4: When program doesn't work**
A:
- Check if Equalizer APO is properly installed
- Verify "Include: Loudness.txt" setting
- Restart "AudioEndpointBuilder" in Windows services

**Q5: Errors during calibration**
A:
- Background noise too high: Measure in quieter environment
- Inconsistent measurements: Fix microphone position and distance
- Measurements too high or low: Re-adjust amp volume

## ⚡ Advanced Tips

### Recommendations for Optimal Use

**Environment Setup**:
- Perform calibration in quiet environment
- Maintain consistent listening environment (chair position, headphone wearing, etc.)
- High-quality headphones/speakers recommended

**Improving Measurement Accuracy**:
- Use average of multiple measurements during calibration
- Fine-tune while actually using at various Target levels
- Measure at consistent times as results may vary by time of day

**Real-World Optimization**:
- Actively use Auto Offset mode
- Identify preferred Target levels by music genre
- Avoid prolonged use above 80dB to protect hearing

### Various Usage Scenarios

#### 💤 Night Listening (Quiet Environment)
- Target: 40-50dB
- Auto Offset: ON
- Maintain rich tone without disturbing neighbors

#### 🎵 General Music Listening
- Target: 60-70dB
- Auto Offset: ON
- Comfortable yet vivid music experience

#### 🎬 Movies/Gaming
- Target: 65-75dB
- Fine-tune per content with Manual mode
- Optimize balance between dialogue and effects

## 📞 Support and Community

### Bug Reports and Improvement Suggestions

If you encounter issues or have improvement ideas, please contact the developer.

### License Information

- Distributed under GPLv3 license
- Open source project - anyone can contribute
- Must comply with license terms for commercial use

## 🎯 Final Note

ApoLoudness is an innovative equal-loudness based volume control tool. It provides a completely different experience from traditional simple volume control, so it may feel unfamiliar at first.

**Calibration is 90% of success**. Accurate measurement is the foundation of perfect tonal balance, so take your time and proceed carefully.

Actively use Auto Offset mode to enjoy ApoLoudness's unique volume control experience. Once you experience it, you won't be able to go back to traditional volume control!

**"Experience the magic of maintaining tonal balance regardless of volume changes!"** ✨

---

## Version History

### v0.3.3 Changes:

* **Fixed Convolution Path**: Now uses "../Filters/" for proper relative path
* **Real SPL Calculation**: Fixed error when Target equals Reference
* **Auto Offset Improvements**: Better wheel accumulator logic
* **Mouse Hook**: Fixed interference with browser scrolling
* **Debug Console**: Removed for cleaner operation
* **Calibration Mode**: Now starts with Reference 80 (not 82)
* **UI Improvements**: Reference Level Selection menu removed (use Alt+Wheel)
* **Calibration Backup**: Previous measurements backed up with timestamp
* **Code Cleanup**: Removed unused variables and improved efficiency

### v0.3.2 Changes:

* **Extended Range**: Target and Reference now support up to 85dB
* **Improved Step Control**: Target adjustment in 1dB increments from 80-85dB
* **Enhanced Multi-Reference Support**: Better preamp calculation for different reference levels
* **Updated Preamp Data**: More accurate preamp values for extended range

### v0.3.1 Changes:

* **Calibration Program**: New dedicated calibration tool
* **Auto Offset Mode**: Automatic tonal balance optimization
* **Real SPL Display**: Shows calibrated sound pressure level
* **Enhanced UI**: Improved interface with dual-line display

### v0.2 Changes:

*   **Improved Controls:** Completely redesigned control scheme for better usability
*   **Context Menu:** Added right-click context menu with Always on Top toggle, Info, and Exit options
*   **Better UX:** More intuitive wheel controls and informative tooltips

### Developer Information

* Developer: grisys/gemini-2.5-pro-preview-05-06
* GitHub: [grisys83/APO-Loudness](https://github.com/grisys83/APO-Loudness)