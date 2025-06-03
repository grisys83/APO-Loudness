# SPL Change Calculator with C-Weighting

## Overview

The `spl_change_at_80-90_C++_stdmap_style_C_weighting.py` script calculates the Sound Pressure Level (SPL) changes when applying equal-loudness compensation filters to pink noise, specifically using C-weighting for measurement. It generates a C++ compatible std::map structure containing recommended preamp values for different target/reference phon combinations.

## Purpose

This script is designed to:
1. Calculate how equal-loudness filters affect the C-weighted SPL of pink noise
2. Determine optimal preamp values to achieve a desired SPL level
3. Prevent clipping by considering the maximum boost of each filter
4. Generate C++ compatible data structures for integration into ApoLoudness

## Technical Details

### Key Concepts

- **C-Weighting**: A frequency weighting curve used in sound level meters, more suitable for higher SPL measurements
- **Pink Noise**: 1/f noise spectrum, commonly used for audio calibration
- **SPL Change**: The difference in measured SPL after applying an equal-loudness filter
- **Preamp Calculation**: Determines the gain adjustment needed to achieve target SPL

### Calculation Process

1. **C-Weighting Filter Design**: Uses matched Z-transform to create digital C-weighting filter
2. **Pink Noise Spectrum**: Generates normalized 1/f power spectrum
3. **Equal-Loudness Filter**: Calculates frequency response for each target/reference combination
4. **SPL Change**: Computes the change in C-weighted power after filtering
5. **Preamp Recommendation**: Balances between:
   - Achieving desired SPL (default: 70 dB SPL(C))
   - Preventing clipping (maintaining -1 dBTP headroom)

### Parameters

- **Calibrated SPL**: 80 dB SPL(C) at Reference=80, Target=80
- **Desired Actual SPL**: 70 dB SPL(C) (configurable)
- **True Peak Headroom**: -1 dBTP (to prevent digital clipping)
- **Sampling Rate**: 48000 Hz
- **Frequency Points**: 512 (logarithmically spaced from 20Hz to 24kHz)

## Output Format

The script generates a C++ std::map structure:

```cpp
std::map<double, std::map<double, double>> recommended_preamp_map = {
    {80.0, { // For Reference Phon 80.0
        {40.0, -27.40}, {40.1, -27.36}, {40.2, -27.31}, ...
    }},
    {81.0, { // For Reference Phon 81.0
        {40.0, -27.42}, {40.1, -27.38}, {40.2, -27.33}, ...
    }},
    // ... continues for each reference level
};
```

## Key Features

- **High Resolution**: 0.1 phon steps for smooth transitions
- **Range Coverage**: 
  - Reference: 80-90 phon (1 phon steps)
  - Target: 40-90 phon (0.1 phon steps)
- **Conservative Design**: Takes the minimum of SPL-based and clipping-prevention preamps
- **Error Handling**: Marks problematic calculations with -99.0 and comments

## Usage

1. Run the script:
   ```bash
   python spl_change_at_80-90_C++_stdmap_style_C_weighting.py
   ```

2. Copy the generated C++ map structure to your source code

3. Adjust parameters if needed:
   - `CALIBRATED_SPL_AT_REF80_TARGET80`: Your calibration reference
   - `USER_DESIRED_ACTUAL_SPL`: Your target listening level
   - `TARGET_TRUE_PEAK_HEADROOM`: Headroom for clipping prevention

## Dependencies

- NumPy
- SciPy (for signal processing and filter design)

## Notes

- C-weighting is more appropriate for moderate to high SPL measurements (70-90 dB)
- The script uses digital filter implementations for accuracy
- Pink noise is used as it represents typical music spectrum better than white noise
- The preamp values ensure both proper SPL and clipping prevention