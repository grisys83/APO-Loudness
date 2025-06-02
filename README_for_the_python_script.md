# SPL Change Calculator for Equal Loudness Filters (C-Weighted Pink Noise)

## Project Overview

This Python script (`spl_change_at_80-90_C++_stdmap_style_C_weighting.py`) is designed to theoretically calculate the Sound Pressure Level (SPL) change when applying various equal loudness compensation filters to a pink noise signal, with the result C-weighted to approximate human hearing perception.

The primary goal is to estimate how much the overall C-weighted SPL of pink noise changes when a specific `TargetPhon-ReferencePhon` equal loudness filter is applied, compared to a reference "flat" filter (e.g., Target 80 Phon / Reference 80 Phon).

This script also generates a C++ `std::map` style output containing recommended initial digital preamp values. These preamp values aim to achieve a user-defined target listening SPL (C-weighted) while also considering the maximum boost of the applied filter to prevent digital clipping.

This tool is particularly useful for developersdiamonds_listeners_of audio software like **ApoLoudness** or VST plugins that implement equal loudness compensation, helping to provide users with informed starting points for their audio setup.

## Features

*   **ISO Curve Interpolation:** Utilizes ISO 226 based equal loudness contour data and interpolates them to generate fine-grained (0.1 Phon step) curves from 0 to 100 Phon.
*   **Accurate C-Weighting Filter:** Implements a C-weighting filter based on IEC 61672-1 standard definitions (using poles and zeros provided by endolith/berndporr) to simulate human hearing response at higher sound levels.
*   **Equal Loudness Filter Simulation:**
    *   Calculates the relative frequency response of equal loudness filters for various `Target Phon` (40.0 dB to 90.0 dB, 0.1 dB increment) and `Reference Phon` (80.0 dB to 90.0 dB, 1.0 dB increment) combinations.
    *   The filter design: 1kHz is normalized to 0dB gain change.
*   **Pink Noise SPL Change Estimation:**
    *   Models a standard pink noise power spectrum (1/f).
    *   Calculates the theoretical change in C-weighted SPL of this pink noise when an equal loudness filter is applied, relative to a flat reference filter (Target 80 Phon / Reference 80 Phon).
*   **Recommended Preamp Calculation:**
    *   Based on the estimated C-weighted SPL change, a user-defined calibrated SPL (e.g., 80 dB SPL(C) for the flat reference), and a user-desired actual listening SPL (e.g., 70 dB SPL(C)).
    *   Also considers the maximum boost introduced by the equal loudness filter to prevent digital clipping (assuming a target true peak headroom, e.g., -1.0 dBTP).
    *   The final recommended preamp is the more conservative (larger attenuation) of the two calculated values.
*   **C++ `std::map` Output:** Generates the results in a C++ `std::map` format for easy integration into other applications. Two maps are generated:
    1.  `filter_max_boost_data`: Shows the maximum boost (dB) of each filter relative to 1kHz.
    2.  `recommended_preamp_map`: Shows the final recommended digital preamp value (dB) for each filter combination.

## How It Works (Calculation Logic)

1.  **ISO & Fine Curves:** Standard ISO equal loudness curves are defined and then interpolated to create a comprehensive set of `fine_curves` at 0.1 Phon intervals.
2.  **C-Weighting Filter:** A digital C-weighting filter is designed using its standard pole/zero definitions. Its frequency response is calculated.
3.  **Pink Noise Spectrum:** A theoretical pink noise power spectrum is generated.
4.  **Reference Power Calculation:** The C-weighted power of the pink noise is calculated when a "flat" equal loudness filter (Target Phon = Reference Phon, e.g., 80/80) is applied. This serves as the 0dB reference for SPL changes.
5.  **For each `ReferencePhon` (80.0 to 90.0):**
    *   **For each `TargetPhon` (40.0 to 90.0):**
        *   **a. EQ Filter Response:** The relative linear gain frequency response of the `TargetPhon-ReferencePhon` equal loudness filter is determined (based on the difference between the `fine_curves` of the Reference and Target Phon, normalized at 1kHz).
        *   **b. Max Boost:** The maximum positive gain (in dB, relative to 1kHz) of this EQ filter is calculated. This is used for clipping prevention.
        *   **c. Filtered Pink Noise Power:** The pink noise spectrum is multiplied by the power response of the EQ filter.
        *   **d. C-Weighted Filtered Power:** The result from (c) is then multiplied by the power response of the C-weighting filter, and the total power is summed.
        *   **e. SPL Change (`spl_change_db_val`):** The ratio of the power from (d) to the reference C-weighted power (from step 4) is converted to dB. This estimates how much the C-weighted SPL of pink noise changes with this specific EQ filter compared to the flat reference.
        *   **f. Preamp for Target SPL:** A preamp value is calculated to try and achieve the `USER_DESIRED_ACTUAL_SPL` given the `CALIBRATED_SPL_AT_REF80_TARGET80` and the `spl_change_db_val`.
            *   `preamp_for_spl_target = USER_DESIRED_ACTUAL_SPL - CALIBRATED_SPL_AT_REF80_TARGET80 - spl_change_db_val`
        *   **g. Preamp for Clipping Avoidance:** Another preamp value is calculated based on the `max_boost_of_eq_filter` and `TARGET_TRUE_PEAK_HEADROOM`.
            *   `preamp_for_clipping_avoidance = TARGET_TRUE_PEAK_HEADROOM - max(0.0, max_boost_of_eq_filter)`
        *   **h. Final Recommended Preamp:** The more conservative (larger attenuation, i.e., more negative or smaller positive) of `preamp_for_spl_target` and `preamp_for_clipping_avoidance` is chosen.
6.  **Output:** The `filter_max_boost_data` and `recommended_preamp_map` are printed in a C++ `std::map` initialization format.

## Script Parameters (User-configurable in the script)

*   `iso_freq`, `iso_curves`: Base data for equal loudness contours.
*   `fs_main`: System sampling rate used for digital filter calculations (e.g., 48000 Hz).
*   `calculation_frequencies_hz`: The frequency points at which responses are calculated.
*   `CALIBRATED_SPL_AT_REF80_TARGET80`: The SPL (C-weighted) measured when a flat filter (Target 80/Ref 80, 0dB Preamp) is active and the analog amplifier is calibrated. (Default: 80.0 dB).
*   `USER_DESIRED_ACTUAL_SPL`: The target C-weighted SPL the user wants to achieve after all processing. (Default: 70.0 dB).
*   `TARGET_TRUE_PEAK_HEADROOM`: The desired headroom to avoid true peak clipping. (Default: -1.0 dBTP).
*   `reference_phon_levels_calc`: Array of Reference Phon levels to iterate over.
*   `target_phon_levels_calc`: Array of Target Phon levels to iterate over.

## Requirements

*   Python 3
*   NumPy: `pip install numpy`
*   SciPy: `pip install scipy`

## How to Run

1.  Ensure you have Python 3, NumPy, and SciPy installed.
2.  Save the script as a `.py` file (e.g., `spl_change_at_80-90_C++_stdmap_style_C_weighting.py`).
3.  Run the script from your terminal: `python spl_change_at_80-90_C++_stdmap_style_C_weighting.py`
4.  The script will print the C++ `std::map` structures to the console. You can copy and paste this output into your C++ code.

## Interpreting the Output

*   **`filter_max_boost_data` map:**
    *   Shows ` {ReferencePhon, {{TargetPhon, MaxBoost_dB}, ...}}`.
    *   `MaxBoost_dB` is the maximum gain the filter applies to any frequency relative to its gain at 1kHz. This helps understand potential for clipping.
*   **`recommended_preamp_map` map:**
    *   Shows ` {ReferencePhon, {{TargetPhon, RecommendedPreamp_dB}, ...}}`.
    *   `RecommendedPreamp_dB` is the suggested digital preamp attenuation. It's calculated to:
        1.  Help achieve the `USER_DESIRED_ACTUAL_SPL` based on the theoretical C-weighted SPL change of pink noise.
        2.  Prevent digital clipping by compensating for the filter's `MaxBoost_dB`, ensuring peaks stay below `TARGET_TRUE_PEAK_HEADROOM`.
        The map provides the more conservative (safer) of these two values.

## Limitations

*   **Theoretical Calculation:** The SPL change is estimated theoretically using a pink noise model and ideal filter responses. Actual perceived loudness and measured SPL with real music content may vary.
*   **Pink Noise Model:** Assumes an ideal 1/f pink noise spectrum.
*   **Filter Implementation:** The accuracy of the C-weighting and equal loudness filter implementations directly impacts the results.
*   **Extrapolation Accuracy:** For Phon levels outside the directly interpolated range of the base ISO curves, the `fine_curves` rely on further interpolation, which might have limitations.
*   **No Dynamic Processing Considered:** This script does not account for any dynamic range compression or limiting that might be present in the audio source or playback chain (e.g., by streaming services, though the goal is to inform settings *before* such processing).

This script provides a valuable theoretical starting point for setting preamp levels in systems employing equal loudness compensation. Experimental verification with actual SPL measurements is always recommended for fine-tuning.

## Developer Information

*   Developer: grisys / Gemini (gemini-2.5-pro-preview-05-06)
*   Inspired by and utilizes concepts from equal loudness compensation research and standard audio weighting filters.
*   The C-weighting filter ZPK calculation is based on work by endolith@gmail.com and mail@berndporr.me.uk.
*   Original ApoLoudness filters and concept by grisys.
*   GitHub (ApoLoudness): [grisys83/APO-Loudness](https://github.com/grisys83/APO-Loudness) 