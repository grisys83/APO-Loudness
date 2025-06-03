# SPL Change Calculator with Z-Weighting

## Overview

The `spl_change_at_75-90_C++_stdmap_style_Z_weighting.py` script calculates Sound Pressure Level (SPL) changes when applying equal-loudness compensation filters to pink noise, using Z-weighting (flat/linear frequency response). It generates a C++ compatible std::map structure containing recommended preamp values for different target/reference phon combinations.

## Purpose

This script is designed to:
1. Calculate how equal-loudness filters affect the Z-weighted (unweighted) SPL of pink noise
2. Determine optimal preamp values to achieve a desired SPL level
3. Prevent clipping by considering the maximum boost of each filter
4. Generate C++ compatible data structures for integration into ApoLoudness

## Key Differences from C-Weighting Version

- **Z-Weighting**: Uses flat/linear frequency response (no frequency weighting)
- **Reference Range**: Covers 75-90 phon (vs 80-90 in C-weighting version)
- **FIR Filter Design**: Actually generates FIR filters using scipy.signal.firwin2
- **More Accurate**: Tests actual filter frequency response instead of theoretical calculations

## Technical Details

### Filter Generation Process

1. **FIR Filter Design**: Creates actual FIR filters with 4095 taps using firwin2
2. **1kHz Normalization**: Ensures 0dB gain at 1kHz reference frequency
3. **Frequency Response**: Calculates actual filter frequency response
4. **SPL Change Calculation**: Computes power change when filtering pink noise
5. **Preamp Optimization**: Balances SPL target and clipping prevention

### Parameters

- **Filter Length**: 4095 taps (odd number for linear phase)
- **Sampling Rate**: 48000 Hz
- **Window Function**: Hann window
- **Frequency Points**: 512 (logarithmically spaced)
- **Calibrated SPL**: 80 dB SPL(Z) at Reference=80, Target=80
- **Desired SPL**: 70 dB SPL(Z)
- **True Peak Headroom**: -1 dBTP

## Output Format

The script generates a C++ std::map structure:

```cpp
std::map<double, std::map<double, double>> recommended_preamp_map_z_weighted_theoretical = {
    {75.0, { // For Reference Phon 75.0
        {40.0, -27.65}, {40.1, -27.61}, {40.2, -27.56}, ...
    }},
    {76.0, { // For Reference Phon 76.0
        {40.0, -27.59}, {40.1, -27.55}, {40.2, -27.50}, ...
    }},
    // ... continues for each reference level up to 90.0
};
```

## Key Features

- **Actual Filter Testing**: Generates real FIR filters and measures their response
- **Progress Monitoring**: Shows real-time progress with ETA
- **Error Handling**: Gracefully handles filter design failures
- **High Resolution**: 0.1 phon steps for smooth transitions
- **Extended Range**: 
  - Reference: 75-90 phon (1 phon steps)
  - Target: 40-90 phon (0.1 phon steps)

## Performance

- Generates approximately 8,016 filter combinations
- Processing time: Several minutes depending on CPU
- Progress updates every 5% completion
- Memory efficient: Processes one filter at a time

## Usage

1. Run the script:
   ```bash
   python spl_change_at_75-90_C++_stdmap_style_Z_weighting.py
   ```

2. Monitor progress output:
   ```
   Processing Z-Weighted Preamp Suggestions for Reference Phon: 75.0...
     Progress: 5.0% (T:44.5 R:75.0 -> Preamp: -26.85 dB) ETA: 180s
   ```

3. Copy the generated C++ map structure to your source code

## Dependencies

- NumPy
- SciPy (for signal processing and FIR filter design)
- Python standard library (time, datetime, json, os)

## Notes

- Z-weighting (flat response) is most accurate for theoretical calculations
- The script validates each filter design before calculating SPL changes
- More computationally intensive than the C-weighting version due to actual filter generation
- Results are optimized for both proper SPL and clipping prevention
- The "theoretical" suffix indicates this uses calculated frequency response rather than actual audio processing