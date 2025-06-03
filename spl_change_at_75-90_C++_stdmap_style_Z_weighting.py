import numpy as np
from scipy import signal
import time # For progress monitoring
from datetime import datetime # For metadata
import json # For metadata (optional)
import os # For creating directory (optional)

# --- ISO Curve Data and Interpolation Functions ---
iso_freq_global = [20, 25, 31.5, 40, 50, 63, 80, 100, 125, 160, 200, 250, 315, 400, 500, 630, 800, 1000, 1250, 1600, 2000, 2500, 3150, 4000, 5000, 6300, 8000, 10000, 12500, 16000, 20000]
iso_curves_global = {
    0: [76.5517, 65.6189, 55.1228, 45.5340, 37.6321, 30.8650, 25.0238, 20.5100, 16.6458, 13.1160, 10.0883, 7.5436, 5.1137, 3.0589, 1.4824, 0.3029, -0.3026, -0.0103, 1.0335, -1.1863, -4.1116, -7.0462, -9.0260, -8.4944, -4.4829, 3.2817, 9.8291, 10.4757, 8.3813, 14.1000, 79.6500],
    10: [83.7500, 75.7579, 68.2089, 61.1365, 54.9638, 49.0098, 43.2377, 38.1338, 33.4772, 28.7734, 24.8417, 21.3272, 18.0522, 15.1379, 12.9768, 11.1791, 9.9918, 9.9996, 11.2621, 10.4291, 7.2744, 4.4508, 3.0404, 3.7961, 7.4583, 14.3483, 20.9841, 23.4306, 22.3269, 25.1700, 81.4700],
    20: [89.5781, 82.6513, 75.9764, 69.6171, 64.0178, 58.5520, 53.1898, 48.3809, 43.9414, 39.3702, 35.5126, 31.9922, 28.6866, 25.6703, 23.4263, 21.4825, 20.1011, 20.0052, 21.4618, 21.4013, 18.1515, 15.3844, 14.2559, 15.1415, 18.6349, 25.0196, 31.5227, 34.4256, 33.0444, 34.6700, 84.1800],
    40: [99.8539, 93.9444, 88.1659, 82.6287, 77.7849, 73.0825, 68.4779, 64.3711, 60.5855, 56.7022, 53.4087, 50.3992, 47.5775, 44.9766, 43.0507, 41.3392, 40.0618, 40.0100, 41.8195, 42.5076, 39.2296, 36.5090, 35.6089, 36.6492, 40.0077, 45.8283, 51.7968, 54.2841, 51.4859, 51.9600, 92.7700],
    60: [109.5113,  104.2279, 99.0779, 94.1773, 89.9635, 85.9434, 82.0534, 78.6546, 75.5635, 72.4743, 69.8643, 67.5348, 65.3917, 63.4510, 62.0512, 60.8150, 59.8867, 60.0116, 62.1549, 63.1894, 59.9616, 57.2552, 56.4239, 57.5699, 60.8882, 66.3613, 71.6640, 73.1551, 68.6308, 68.4300, 104.9200],
    80: [118.9900, 114.2326, 109.6457, 105.3367, 101.7214, 98.3618, 95.1729, 92.4797, 90.0892, 87.8162, 85.9166, 84.3080, 82.8934, 81.6786, 80.8634, 80.1736, 79.6691, 80.0121, 82.4834, 83.7408, 80.5867, 77.8847, 77.0748, 78.3124, 81.6182, 86.8087, 91.4062, 91.7361, 85.4068, 84.6700, 118.9500],
    100: [128.4100, 124.1500, 120.1100, 116.3800, 113.3500, 110.6500, 108.1600, 106.1700, 104.4800, 103.0300, 101.8500, 100.9700, 100.300, 99.8300, 99.6200, 99.500, 99.4400, 100.0100, 102.8100, 104.2500, 101.1800, 98.4800, 97.6700, 99.00, 102.300, 107.2300, 111.1100, 110.2300, 102.0700, 100.8300, 133.7300]
}
def create_primary_interpolated_curves(curves_data, iso_freq_list_param):
    primary_curves_result = {}
    for phon_level in [0, 10, 20, 40, 60, 80, 100]:
        if phon_level in curves_data: primary_curves_result[phon_level] = curves_data[phon_level][:]
    for phon_level in [30, 50, 70, 90]:
        lower_phon = phon_level - 10; upper_phon = phon_level + 10
        if lower_phon in curves_data and upper_phon in curves_data:
            weight = 0.5; lower_curve = np.array(curves_data[lower_phon]); upper_curve = np.array(curves_data[upper_phon])
            primary_curves_result[phon_level] = (lower_curve * (1 - weight) + upper_curve * weight).tolist()
    return primary_curves_result

curves_for_fine_interpolation_global = create_primary_interpolated_curves(iso_curves_global, iso_freq_global)

def create_fine_interpolated_curves(base_curves_data, iso_freq_list_param, step=0.1):
    fine_curves_result = {}; sorted_phon_levels = sorted(base_curves_data.keys())
    for phon_val_int in range(int(0.0 * 10), int(100.0 * 10) + int(step * 10), int(step*10)):
        phon_val_rounded = round(phon_val_int / 10.0, 1); lower_phon_base = -1; upper_phon_base = -1
        for i in range(len(sorted_phon_levels)):
            if sorted_phon_levels[i] <= phon_val_rounded: lower_phon_base = sorted_phon_levels[i]
            if sorted_phon_levels[i] >= phon_val_rounded: upper_phon_base = sorted_phon_levels[i];
            if lower_phon_base != -1 and upper_phon_base != -1 and sorted_phon_levels[i] >= phon_val_rounded : break
        if lower_phon_base == -1 : lower_phon_base = sorted_phon_levels[0]
        if upper_phon_base == -1 : upper_phon_base = sorted_phon_levels[-1]
        if lower_phon_base == upper_phon_base: interpolated_curve_list = base_curves_data[lower_phon_base][:]
        else:
            denominator = upper_phon_base - lower_phon_base
            weight = (phon_val_rounded - lower_phon_base) / denominator if denominator != 0 else 0
            lower_curve = np.array(base_curves_data[lower_phon_base]); upper_curve = np.array(base_curves_data[upper_phon_base])
            interpolated_curve_list = (lower_curve * (1 - weight) + upper_curve * weight).tolist()
        fine_curves_result[phon_val_rounded] = [round(val, 4) for val in interpolated_curve_list]
    return fine_curves_result

fine_curves_global = create_fine_interpolated_curves(curves_for_fine_interpolation_global, iso_freq_global, step=0.1)

def design_fir_filter_with_firwin2_controlled(target_phon, reference_phon, numtaps, fs, 
                                             iso_freq_list, fine_curves_data, window='hann'):
    target_phon_key = round(float(target_phon), 1)
    reference_phon_key = round(float(reference_phon), 1)
    
    effective_numtaps = numtaps
    if numtaps % 2 == 0:
        effective_numtaps = numtaps + 1

    if target_phon_key not in fine_curves_data or reference_phon_key not in fine_curves_data:
        return np.zeros(effective_numtaps), {'error': 'Phon data not found'}
    
    target_curve_spl = np.array(fine_curves_data[target_phon_key])
    reference_curve_spl = np.array(fine_curves_data[reference_phon_key])
    db_diff = reference_curve_spl - target_curve_spl
    try: idx_1khz = iso_freq_list.index(1000)
    except ValueError: return np.zeros(effective_numtaps), {'error': '1000Hz not found'}
        
    reference_db_at_1khz = db_diff[idx_1khz]
    relative_gains_db_at_iso = reference_db_at_1khz - db_diff
    relative_gains_linear_at_iso = 10**(relative_gains_db_at_iso / 20.0)
    
    nyquist = fs / 2.0
    norm_freqs = [0.0] + [f / nyquist for f in iso_freq_list if 0 < f < nyquist] + [1.0]
    norm_gains = [relative_gains_linear_at_iso[0]] + \
                 [g for f, g in zip(iso_freq_list, relative_gains_linear_at_iso) if 0 < f < nyquist] + \
                 [relative_gains_linear_at_iso[-1]]
    
    final_norm_freqs, final_indices = np.unique(norm_freqs, return_index=True)
    final_norm_gains = np.array(norm_gains)[final_indices]
            
    fir_coeff = np.zeros(effective_numtaps)
    try:
        fir_coeff = signal.firwin2(effective_numtaps, final_norm_freqs, final_norm_gains, 
                                   window=window, nfreqs=None)
        w_1k, h_1k_complex = signal.freqz(fir_coeff, worN=[1000], fs=fs)
        gain_at_1k_actual = np.abs(h_1k_complex[0])
        if gain_at_1k_actual > 1e-9: fir_coeff /= gain_at_1k_actual
    except Exception as e:
        return np.zeros(effective_numtaps), {'error': str(e)}
    return fir_coeff, {} # Return empty info if successful, error info handled above

def get_eq_filter_freq_response_linear(fir_coefficients, fs, target_frequencies_hz):
    if not np.any(fir_coefficients): return None
    w, h_complex = signal.freqz(fir_coefficients, worN=target_frequencies_hz, fs=fs)
    return np.abs(h_complex)

def get_pink_noise_power_spectrum_linear(frequencies_hz):
    frequencies_hz = np.maximum(frequencies_hz, 1e-6)
    power_spectrum = 1.0 / frequencies_hz
    return power_spectrum / np.sum(power_spectrum)

def get_max_boost_from_coeffs(fir_coefficients, fs, iso_freq_list_param):
    if not np.any(fir_coefficients): return 0.0
    gains_linear = get_eq_filter_freq_response_linear(fir_coefficients, fs, iso_freq_list_param)
    if gains_linear is None: return 0.0
    
    # Normalize to 1kHz gain before finding max boost
    gain_at_1khz = np.interp(1000, iso_freq_list_param, gains_linear) # Get gain at 1kHz
    if gain_at_1khz < 1e-9: return 0.0 # Avoid division by zero if 1kHz gain is ~0
    
    relative_gains_linear = gains_linear / gain_at_1khz
    gains_db = 20 * np.log10(np.maximum(relative_gains_linear, 1e-9))
    return np.max(gains_db)

# --- Main Calculation Loop for Z-Weighted Preamp Map ---
FS_MAIN = 48000
NUMTAPS_MAIN = 4095 # Using an odd number of taps

# For theoretical SPL_Change_Z calculation
min_freq_calc = 20.0
max_freq_calc = FS_MAIN / 2.0 -1 
num_freq_points_calc = 512 
calculation_frequencies_hz = np.logspace(np.log10(min_freq_calc), np.log10(max_freq_calc), num_freq_points_calc)
pink_noise_power_spec = get_pink_noise_power_spectrum_linear(calculation_frequencies_hz)

# Reference power for Z-weighted SPL change (Target 80 / Ref 80 filter)
coeffs_80_80, _ = design_fir_filter_with_firwin2_controlled(80.0, 80.0, NUMTAPS_MAIN, FS_MAIN, iso_freq_global, fine_curves_global)
eq_filter_flat_gains_lin_z = get_eq_filter_freq_response_linear(coeffs_80_80, FS_MAIN, calculation_frequencies_hz)

if eq_filter_flat_gains_lin_z is None:
    print("Error: Could not calculate flat EQ filter for Z-weighted reference power.")
    level_ref_z_weighted_power_val = 1.0 # Fallback
else:
    power_after_flat_eq_ref_z = pink_noise_power_spec * (eq_filter_flat_gains_lin_z**2)
    level_ref_z_weighted_power_val = np.sum(power_after_flat_eq_ref_z) 
    if level_ref_z_weighted_power_val < 1e-12: # Check if too close to zero
        print("Warning: Reference Z-weighted power is very close to zero.")
        level_ref_z_weighted_power_val = 1e-12


CALIBRATED_SPL_AT_REF80_TARGET80_Z = 80.0 # dB SPL(Z) - User's amp calibration point
USER_DESIRED_ACTUAL_SPL_Z = 70.0         # dB SPL(Z) - User's target listening level
TARGET_TRUE_PEAK_HEADROOM_TP = -1.0      # dBTP

recommended_preamp_map_z_theoretical = {}
reference_phon_levels_calc = np.arange(75.0, 90.1, 1.0)
target_phon_levels_calc = np.arange(40.0, 90.1, 0.1)

total_filters_to_gen = len(reference_phon_levels_calc) * len(target_phon_levels_calc)
generated_count = 0
start_time_total = time.time()

for ref_phon in reference_phon_levels_calc:
    ref_phon_key = round(ref_phon, 1)
    recommended_preamp_map_z_theoretical[ref_phon_key] = {}
    print(f"Processing Z-Weighted Preamp Suggestions for Reference Phon: {ref_phon_key:.1f}...")
    for target_phon_int in range(int(40.0 * 10), int(90.0 * 10) + 1):
        target_phon = round(target_phon_int / 10.0, 1)
        generated_count +=1

        current_fir_coeffs, info = design_fir_filter_with_firwin2_controlled(
            target_phon, ref_phon_key, NUMTAPS_MAIN, FS_MAIN,
            iso_freq_global, fine_curves_global
        )
        if 'error' in info or not np.any(current_fir_coeffs):
            recommended_preamp_map_z_theoretical[ref_phon_key][target_phon] = f"FilterErr: {info.get('error', 'Unknown')}"
            if generated_count % (total_filters_to_gen // 20 if total_filters_to_gen > 20 else 1) == 0:
                 print(f"  Progress: {generated_count / total_filters_to_gen * 100:.1f}% (Filter error at T:{target_phon} R:{ref_phon_key})")
            continue

        # 1. Theoretical Z-weighted SPL Change
        eq_gains_lin_current = get_eq_filter_freq_response_linear(current_fir_coeffs, FS_MAIN, calculation_frequencies_hz)
        spl_change_z_db_val = 0.0
        if eq_gains_lin_current is not None and level_ref_z_weighted_power_val > 1e-12:
            power_after_eq_current_z = pink_noise_power_spec * (eq_gains_lin_current**2)
            level_final_z_weighted_power_current = np.sum(power_after_eq_current_z)
            ratio_spl_z = level_final_z_weighted_power_current / level_ref_z_weighted_power_val
            if ratio_spl_z > 1e-12: # Avoid log of zero or negative
                spl_change_z_db_val = 10 * np.log10(ratio_spl_z)
            else:
                spl_change_z_db_val = -99.0 # Indicate very large attenuation
        
        preamp_for_spl_target_z = USER_DESIRED_ACTUAL_SPL_Z - CALIBRATED_SPL_AT_REF80_TARGET80_Z - spl_change_z_db_val
        if np.isinf(preamp_for_spl_target_z) or np.isnan(preamp_for_spl_target_z): preamp_for_spl_target_z = -99.0
        
        # 2. Max Boost for Clipping Avoidance
        max_boost_of_eq_filter = get_max_boost_from_coeffs(current_fir_coeffs, FS_MAIN, iso_freq_global)
        preamp_for_clipping_avoidance = TARGET_TRUE_PEAK_HEADROOM_TP - max(0.0, max_boost_of_eq_filter)
        
        final_recommended_preamp_z = min(preamp_for_spl_target_z, preamp_for_clipping_avoidance)
        recommended_preamp_map_z_theoretical[ref_phon_key][target_phon] = round(final_recommended_preamp_z, 2)
        
        if generated_count % (total_filters_to_gen // 20 if total_filters_to_gen > 20 else 1) == 0: # Print progress roughly every 5%
            elapsed = time.time() - start_time_total
            eta = elapsed / generated_count * (total_filters_to_gen - generated_count) if generated_count > 0 else 0
            print(f"  Progress: {generated_count / total_filters_to_gen * 100:.1f}% (T:{target_phon:.1f} R:{ref_phon_key:.1f} -> Preamp: {final_recommended_preamp_z:.2f} dB) ETA: {eta:.0f}s", end = '\r')


# --- C++ std::map 스타일로 Z-weighted 기반 최종 권장 프리앰프 맵 출력 ---
print(f"\n\n// --- Recommended Preamp Map (Z-Weighted SPL Change Theoretical Estimation) ---")
print(f"// Based on: CALIBRATED_SPL_AT_REF80_TARGET80_Z = {CALIBRATED_SPL_AT_REF80_TARGET80_Z:.1f} dB SPL(Z)")
print(f"//           USER_DESIRED_ACTUAL_SPL_Z = {USER_DESIRED_ACTUAL_SPL_Z:.1f} dB SPL(Z)")
print(f"//           TARGET_TRUE_PEAK_HEADROOM_TP = {TARGET_TRUE_PEAK_HEADROOM_TP:.1f} dBTP")
print("std::map<double, std::map<double, double>> recommended_preamp_map_z_weighted_theoretical = {")
for ref_ph, t_map in recommended_preamp_map_z_theoretical.items():
    print(f"    {{{ref_ph:.1f}, {{ // For Reference Phon {ref_ph:.1f}")
    cnt = 0; l_content = []
    sorted_t_phons = sorted([k for k in t_map.keys() if isinstance(k, float)]) # Ensure keys are float for sorting
    for t_ph in sorted_t_phons:
        p_val = t_map.get(t_ph, "Error") # Should always exist now
        l_content.append(f"{{{t_ph:.1f}, {(p_val if isinstance(p_val, str) else f'{p_val:.2f}')}}}")
        cnt += 1
        if cnt % 5 == 0 or t_ph == sorted_t_phons[-1]:
            if l_content: print(f"        {', '.join(l_content)},")
            l_content = []
    print("    }},")
print("};")
