# ApoLoudness v0.2 - Equal Loudness Compensation Helper for a Precise Cognitive Audio Experience

Hello! ApoLoudness is a utility designed to work alongside Equalizer APO, helping you achieve a balanced sound experience at any volume level through Equal Loudness Compensation. It's specifically designed to compensate for the loss of low and high frequencies often experienced at low volumes, allowing you to enjoy all the details in your music while protecting your hearing.

This program automatically applies pre-generated, high-precision FIR filters (`.wav` files) to Equalizer APO's configuration file (`Loudness.txt`) based on your settings.

**v0.2 Changes:**

*   **Improved Controls:** Completely redesigned control scheme for better usability
*   **Context Menu:** Added right-click context menu with Always on Top toggle, Info, and Exit options
*   **Better UX:** More intuitive wheel controls and informative tooltips

## Key Features

*   **Intuitive Mouse Controls:** Easy-to-use mouse wheel and modifier key combinations for quick adjustments
*   **Context Menu:** Right-click access to settings and information
*   **Utilizes Precision FIR Filters:** Leverages a set of high-quality FIR filters generated with 0.1 Phon granularity based on ISO 226 standards
*   **Digital Preamp Adjustment:** Allows you to adjust a digital preamp value to prevent digital clipping and fine-tune your target listening level
*   **Real-time Configuration Updates:** Changes are immediately reflected in the `C:/Program Files/EqualizerAPO/config/Loudness.txt` file
*   **Always On Top:** Optional window stays on top of other windows for easy access

## Requirements

*   **Windows Operating System**
*   **Equalizer APO Installed:** You must download and install Equalizer APO beforehand from the [Equalizer APO Official Website](https://sourceforge.net/projects/equalizerapo/)
*   **ApoLoudness Filter Files:** You will need the `*.wav` filter files that come with this program (or are downloaded from grisys's GitHub repository). By default, these filters should be placed in the `C:/Program Files/EqualizerAPO/config/Filters/` directory

## Installation

1.  **Install Equalizer APO:** If you haven't already, download and install it from the link above. During installation, you'll need to select the playback device(s) to which Equalizer APO will apply.
2.  **Prepare ApoLoudness Filter Files:**
    *   Download the filter files from the `https://github.com/grisys83/FIR-Filter-Maker-for-Equal-Loudness` GitHub repository
    *   Place the downloaded filter files into `C:/Program Files/EqualizerAPO/config/Filters/`
3.  **Run ApoLoudness:** Execute the `ApoLoudness.exe` file.

## How to Use

The ApoLoudness window displays the currently set **"Target Phon / Reference Phon dB"** values.

### 🎛️ **New Improved Controls:**

*   **Mouse Wheel (Default)**: Adjust Target Phon (60.0~80.0dB, 0.1dB steps)
    *   The most frequently used control for fine-tuning your listening level
*   **Shift + Mouse Wheel**: Adjust Preamp Offset (±5.0dB, 0.1dB steps)
    *   Fine-tune the preamp for clipping prevention and volume adjustment
*   **Ctrl + Mouse Wheel**: Change Reference Phon (80.0~90.0dB, 1.0dB steps)
    *   Set your reference loudness level (less frequently changed)
*   **Right Click**: Open Context Menu
    *   Toggle Always on Top
    *   Show Info dialog
    *   Exit application
*   **Double Click**: Reset all settings to default values
*   **Middle Click**: Reset Preamp Offset to 0.0dB

### 📊 **Understanding the Settings:**

**Target Phon:** The loudness level you want your music to sound like (60.0-80.0dB)
**Reference Phon:** The reference loudness level for filter calculation (80.0-90.0dB)  
**Preamp Offset:** User adjustment to the recommended preamp value (±5.0dB)

The program automatically calculates the optimal preamp setting based on your Target and Reference Phon values, and you can add a personal offset for fine-tuning.

### 🎵 **Pink Noise Calibration for Precise Listening (Recommended):**

The true value of this software lies in precise listening environment setup. The pink noise calibration method below will help you experience optimally compensated sound at your desired sound pressure level while protecting your hearing.

**Prerequisites:**
*   SPL Meter (with C-weighting capability)
*   Pink Noise test tone (e.g., a standard pink noise file at -20dBFS RMS)
*   Music Player and your audio system

**Calibration Procedure:**

*   **Step 1: Set Baseline SPL (Amplifier Calibration)**
    1.  Set ApoLoudness to: Reference Phon 80.0dB, Target Phon 80.0dB, Preamp Offset 0.0dB
    2.  Play pink noise and measure SPL at your listening position (C-weighting)
    3.  Adjust your amplifier volume to your desired safe maximum level (e.g., 75-80dB SPL(C))
    4.  Mark this amplifier position as your "Reference Volume"

*   **Step 2: Set Your Preferred Listening Level**
    1.  Adjust Target Phon in ApoLoudness to your preferred quiet listening level (e.g., 65.0dB)
    2.  Keep your amplifier at the "Reference Volume" position
    3.  Enjoy balanced sound at a lower, hearing-safe volume level

## Troubleshooting

*   **No sound or no change in sound:**
    *   Ensure Equalizer APO is installed correctly and the playback device is selected
    *   Check if the `C:/Program Files/EqualizerAPO/config/Loudness.txt` file is being modified
    *   Open Equalizer APO's Configuration Editor to verify the Loudness.txt content is loaded

*   **Errors about missing filter files:**
    *   Verify filter files are in `C:/Program Files/EqualizerAPO/config/Filters/`
    *   Check that filter filenames match the expected format: `XX.X-YY.Y_filter.wav`

## License

GPLv3

## Developer Information

* Developer: grisys/gemini-2.5-pro-preview-05-06
* GitHub: [grisys83/APO-Loudness](https://github.com/grisys83/APO-Loudness)