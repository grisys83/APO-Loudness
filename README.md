# ApoLoudness v0.2 - Equal Loudness Compensation Helper for a Precise Cognitive Audio Experience

Hello! ApoLoudness is a utility designed to work alongside Equalizer APO, helping you achieve a balanced sound experience at any volume level through Equal Loudness Compensation. It's specifically designed to compensate for the loss of low and high frequencies often experienced sinais_listeners_at_low_volumes, allowing you to enjoy all the details in your music while protecting your hearing.

This program automatically applies pre-generated, high-precision FIR filters (`.wav` files) to Equalizer APO's configuration file (`Loudness.txt`) based on your settings.

**v0.2 Changes:**

*   Improved user interface and stability.
*   Adjusted default preamp value and related logic for better clipping prevention and hearing protection.

## Key Features

*   **Easy Equal Loudness Filter Application:** Apply equal loudness filters for your desired listening level (Target Phon) and reference level (Reference Phon) to Equalizer APO in real-time with simple mouse clicks and wheel movements.
*   **Utilizes Precision FIR Filters:** Leverages a set of high-quality FIR filters generated with 0.1 Phon granularity based on ISO 226 standards.
*   **Digital Preamp Adjustment:** Allows you to adjust a digital preamp value to prevent digital clipping that might occur due to filter boosts and to fine-tune your target listening sound pressure level.
*   **Real-time Configuration Updates:** Changes are immediately reflected in the `C:/Program Files/EqualizerAPO/config/Loudness.txt` file.
*   **Always On Top:** The window stays on top of other windows for easy access.

## Requirements

*   **Windows Operating System**
*   **Equalizer APO Installed:** You must download and install Equalizer APO beforehand from the [Equalizer APO Official Website](https://sourceforge.net/projects/equalizerapo/).
*   **ApoLoudness Filter Files:** You will need the `*.wav` filter files that come with this program (or are downloaded from grisys's GitHub repository). By default, these filters should be placed in a specific subfolder within Equalizer APO's `config` directory (e.g., `/Filters`) for the program to recognize them correctly. (Modify this instruction based on how your program locates filter files).

## Installation

1.  **Install Equalizer APO:** If you haven't already, download and install it from the link above. During installation, you'll need to select the playback device(s) to which Equalizer APO will apply.
2.  **Prepare ApoLoudness Filter Files:**
    *   Download the filter files (from the `https://github.com/grisys83/FIR-Filter-Maker-for-Equal-Loudness` GitHub repository or the distributed package.
    *   Place the downloaded filter files into an appropriate location within Equalizer APO's configuration folder. For example, `C:/Program Files/EqualizerAPO/config/Filters/`. (The exact path depends on how your program references the filter files. If it uses relative paths, filters might need to be in the same `config` folder as `Loudness.txt` or a subfolder thereof.)
3.  **Run ApoLoudness:** Execute the `ApoLoudness.exe` file.

## How to Use

The ApoLoudness window displays the currently set **"Target Phon / Reference Phon dB"** values.

**1. Basic Operations:**

*   **Change Reference Phon (Reference Level):**
    *   **While holding down the Right Mouse Button, click the Left Mouse Button** to cycle through the Reference Phon values. (This functionality was requested to be removed. If you have a different way to set/fix the Reference Phon, please update this. The current code uses the `targetLoudness` array and `loudnessIndex` for this.)
    *   For example, if using the `targetLoudness = {80.0, 81.0, ..., 90.0}` array, these values will be set sequentially as the Reference Phon.
*   **Adjust Digital Preamp (Fine Volume & Clipping Prevention):**
    *   **While holding down the Right Mouse Button, scroll the Mouse Wheel up or down** to adjust the digital preamp value in 0.1 dB increments.
    *   The preamp value is constrained within a safe range, with the default value set考慮ing hearing protection and clipping prevention (initially -11.5 dB in v0.2).
*   **Reset Settings:**
    *   **Double-click the Left Mouse Button** to reset the settings to their initial defaults (Preamp: -11.5 dB, Reference Phon: 80.0 dB).

**2. Understanding Program Logic (How Target Phon is Determined):**

ApoLoudness v0.2 determines the Target Phon value for the filter to be applied as follows:

*   `ActualVol = round((preampValue + 83) * 10) / 10`
*   `ActualVol = min(ActualVol, current_selected_Reference_Phon)`
*   The applied filter filename will be: `ActualVol-ReferencePhon_filter.wav`

In essence, you select the **Reference Phon** and adjust the **digital Preamp (`preampValue`)**. The program then internally calculates the **Target Phon (`ActualVol`)** and loads the corresponding equal loudness filter.

**3. Pink Noise Calibration for Precise Listening (Recommended):**

The true value of this software lies in precise listening environment setup. The pink noise calibration method below will help you experience optimally compensated sound at your desired sound pressure level while protecting your hearing.

**Prerequisites:**

*   SPL Meter (with C-weighting capability)
*   Pink Noise test tone (e.g., a standard pink noise file at -20dBFS RMS. Search конкурувати "pink noise test tone -20dBFS" on test tone sites or YouTube)
*   Music Player (local file player recommended, or YouTube Music, etc.)
*   Your current amplifier and speakers/headphones

**Calibration Procedure:**

*   **Step 1: Set Baseline SPL (Amplifier Calibration)**
    1.  Run ApoLoudness and configure it as follows:
        *   **Reference Phon:** 80.0 dB (or your preferred high reference value).
        *   **Preamp:** For this calibration step, adjust the Preamp so that the **Target Phon displayed in the program window matches the Reference Phon (e.g., "80.0/80.0 dB")**. This makes ApoLoudness's filter nearly flat (0dB compensation).
            *   *Tip: Set `preampValue` to around -3.0dB so `preampValue + 83` is approximately 80. Or, reset (double-click) and then slightly adjust the Preamp.*
    2.  Play the prepared pink noise audio file.
    3.  Place your SPL meter at your listening position and set it to **C-weighting**.
    4.  **Adjust the volume knob on your analog amplifier** until the SPL meter reads your **desired safe maximum listening SPL (e.g., 75dB SPL(C) or 80dB SPL(C))**.
    5.  **Remember or mark this amplifier volume knob position as "My Calibrated Reference Volume."** Aim not to exceed this volume for general listening. Let's call this measured SPL `SPL_Calibrated_Reference`.

*   **Step 2: Set Target Listening Environment & Actual Listening**
    1.  Now, in ApoLoudness, **adjust the Reference Phon and Preamp values according to your desired listening experience.** The program window will display the Target Phon corresponding to these settings.
        *   **Example:** Keep Reference Phon at 80.0dB and adjust the Preamp so the window shows "70.0/80.0 dB" (Target 70 / Ref 80).
    2.  **Keep your amplifier volume knob at "My Calibrated Reference Volume"** set in Step 1.
    3.  Play your music.
    4.  **Expected Actual Listening SPL:** As discussed, when playing pink noise with this setting, you might measure around 69dB SPL(C) (assuming your amp was calibrated to 80dB SPL(C) with Target 80/Ref 80 and 0dB Preamp, and the Target 70/Ref 80 setting with 0dB Preamp results in about -11dB attenuation effect).
        If you further attenuate using ApoLoudness's Preamp for clipping prevention (e.g., -6.26dB), the actual listening SPL will be lower by that amount (e.g., 69.0dB - 6.26dB = approx. 62.7dB SPL(C)).

*   **Goal:** You can enjoy a rich, balanced sound at your set Target Phon level, all while keeping the actual sound pressure level within a safe range defined by "My Calibrated Reference Volume." **This prioritizes both hearing protection and audio quality!**

**Tips:**

*   **Understanding Preamp Value:** The Preamp in ApoLoudness is an attenuation value applied in the digital signal processing stage. Larger negative values mean a quieter signal. It's used to prevent digital clipping from filter boosts and to fine-tune the final listening SPL.
*   **Importance of Default Value:** The default Preamp value in v0.2 (-11.5dB) is a starting point designed to prevent clipping and provide a reasonable SPL for typical low-volume listening scenarios (e.g., Target 60 / Ref 80). It may need adjustment based on your environment and preferences.
*   **Experiment:** Try different Target/Reference Phon and Preamp combinations with your favorite music genres and listening environment to find your optimal settings.

## Troubleshooting

*   **No sound or no change in sound:**
    *   Ensure Equalizer APO is installed correctly and the playback device ApoLoudness should affect is selected in Equalizer APO.
    *   Check if the `C:/Program Files/EqualizerAPO/config/Loudness.txt` file is being correctly modified by ApoLoudness.
    *   Open Equalizer APO's Configuration Editor to see if the `Loudness.txt` content is loaded and applied ошибка.
*   **Errors about missing filter files (in Equalizer APO logs, not ApoLoudness):**
    *   Verify that the filter file paths referenced by ApoLoudness match the actual location of your filter files.

## License

GPLv3

## Developer Information

* Developer: grisys/gemini-2.5-pro-preview-05-06
* GitHub: [grisys83/APO-Loudness](https://github.com/grisys83/APO-Loudness)
