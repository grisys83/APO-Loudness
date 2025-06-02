# ApoLoudness User Manual v0.3.1

## 🎵 What is ApoLoudness?

**"An innovative audio tool that maintains tonal balance regardless of volume changes"**

ApoLoudness is a program that maintains the same tonal balance as 80dB even at low volumes. This allows you to enjoy rich bass and natural timbre while protecting your hearing.

## 🔬 How It Works (Simple Explanation)

Human ears have different frequency sensitivities depending on volume. At quiet levels, bass and treble are relatively harder to hear. ApoLoudness precisely corrects this based on equal-loudness contours.

- **Traditional volume control**: All frequencies ↑↓ equally → Tonal balance changes
- **ApoLoudness**: Custom adjustment per frequency ↕️ → Tonal balance maintained ✨

## 📥 Download and Installation

### Download Links

- **Program + 48kHz filters**: [Download](https://github.com/grisys83/APO-Loudness/releases)
- **44.1kHz filters**: [Download](https://github.com/grisys83/APO-Loudness/releases)

### ⚠️ Important Legal Notice

- By extracting the compressed file, you agree to the GPLv3 license
- All usage responsibility lies with the user
- Archive password: `agree`

### Installation Steps

#### Step 1: Install Main Program
```
Extract APOLoudness_v0.3.1_portable.zip
↓
Copy to C:\Program Files\EqualizerAPO\config\ folder
```

#### Step 2: Install Filter Files (44.1kHz users only)
```
44100Hz filter files
↓
Copy to C:\Program Files\EqualizerAPO\config\Filters\ folder (overwrite)
```

#### Step 3: Configure Equalizer APO
In Equalizer APO configuration:
```
Include: Loudness.txt
```
Add (headphone EQ is optional)

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

#### Step 3: Step-by-Step Measurement (70dB → 60dB → 50dB → 40dB)

1. In ApoLoudness window, scroll mouse wheel to set Target to 70
2. Click "Play Test Tone" in Calibration
3. Enter SPL meter reading in "Measured SPL"
4. Click Next
5. Repeat for 60dB, 50dB, 40dB

#### Step 4: Save

- After all measurements complete, click "Save Calibration"
- If failed, restart programs and try again

### 💡 Calibration Tips

- If "Play Test Tone" is disabled, press Stop button to re-enable
- If measurements seem off, check background noise or microphone position
- Recommend measuring multiple times for consistent values

## 🚀 How to Use

### Auto Offset Mode (Recommended)

After calibration is complete, turning on Auto Offset lets you experience the true value of ApoLoudness.

**Auto Offset Features**:
- Target and Real automatically linked
- Optimal Offset automatically calculated when scrolling
- Perfect tonal balance maintained

**How to Use**:
1. ApoLoudness right-click → Check "Auto Offset"
2. Hover mouse over program window → Adjust volume with scroll wheel
3. Double-click: Restore defaults (Target 60, Real 60 SPL)

### Manual Mode (Advanced Users)

Use when you want fine manual adjustments with Auto Offset off.

**Controls**:
- **Scroll wheel**: Adjust Offset (like normal volume)
- **Ctrl + wheel**: Adjust Target (maintain bass while adjusting volume)
- **Alt + wheel**: Adjust Reference (advanced setting)

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

## Legacy v0.2 Documentation

### v0.2 Changes:

*   **Improved Controls:** Completely redesigned control scheme for better usability
*   **Context Menu:** Added right-click context menu with Always on Top toggle, Info, and Exit options
*   **Better UX:** More intuitive wheel controls and informative tooltips

### Developer Information

* Developer: grisys/gemini-2.5-pro-preview-05-06
* GitHub: [grisys83/APO-Loudness](https://github.com/grisys83/APO-Loudness)