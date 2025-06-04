================================================================================
                         ApoLoudness v0.3.5 Quick Guide
================================================================================

ApoLoudness - Equal-loudness volume control for Equalizer APO
Maintains optimal tonal balance at any volume level

================================================================================
INSTALLATION
================================================================================

1. Requirements:
   - Windows 10/11
   - Equalizer APO installed
   - Administrator privileges

2. Install:
   - Run ApoLoudness_v0.3.5_Setup.exe
   - Follow installer prompts
   - Confirm sample rate (44.1kHz or 48.0kHz)

3. First Run:
   - Launch ApoLoudness from Start Menu
   - Perform calibration (see below)

================================================================================
QUICK START - CALIBRATION
================================================================================

Required: Smartphone with SPL meter app (NIOSH Sound Level Meter recommended)

1. Launch ApoLoudnessCalibration.exe and ApoLoudness.exe
2. In ApoLoudness: Right-click → Check "Calibration Mode"
3. Set Windows volume to 100%, reduce amp volume
4. Play pink noise, adjust amp until SPL meter shows 80 dB
5. Measure at least: Reference 80 with Targets 40, 50, 60, 70, 80
6. Save calibration when complete

================================================================================
MOUSE CONTROLS
================================================================================

When mouse over window:
- Wheel: Volume control (varies by mode)
- Ctrl + Wheel: Target adjustment (1 dB steps)
- Alt + Wheel: Reference adjustment (75-90 dB)
- Double Click: Reset to defaults
- Right Click: Context menu

Global (anywhere on screen):
- Right Mouse + Wheel: Auto activate Auto Offset + volume control

================================================================================
NEW IN v0.3.5 - ENHANCED AUTO OFFSET
================================================================================

Auto Offset now works with ANY reference level (75-90), not just 80!

Examples:
- Reference 75: Maximum tone enhancement for quiet listening
- Reference 80: Balanced for general use
- Reference 85: Minimal processing for dynamic content

How it works:
- Below your reference: Maintains tone balance correction
- Above your reference: Automatically adjusts to preserve natural sound

================================================================================
DISPLAY EXPLANATION
================================================================================

73.5 dB      <- Real SPL at your ears (color-coded)
Safe: 24h+   <- Safe listening time
T60 R80 O+2.0 P:-12  <- Technical details

Color coding:
- Green (≤65 dB): Very Safe
- Yellow (65-73 dB): Safe  
- Light Red (73-80 dB): Caution
- Pink (80-85 dB): Warning
- Red (≥85 dB): Danger

================================================================================
RECOMMENDED SETTINGS BY CONTENT
================================================================================

Classical/Jazz:    Reference 75-78 (enhanced detail at low volumes)
Rock/Pop:          Reference 78-82 (balanced tone)
Movies/Gaming:     Reference 82-85 (preserve dynamics)
Late Night:        Reference 75 (maximum compensation)

================================================================================
TROUBLESHOOTING
================================================================================

Sound too quiet/loud:
- Check Auto Offset is ON
- Verify Reference setting (Alt + Wheel)
- Check system/amp volume

Program not working:
- Verify Equalizer APO installed
- Check config includes: ApoLoudness\ApoLoudness.txt
- Restart AudioEndpointBuilder service

================================================================================
SAFETY GUIDELINES
================================================================================

Based on NIOSH standards with 80% safety margin:
- Below 65 dB: Safe for 24+ hours
- 65-73 dB: Safe for extended periods
- 73-80 dB: Monitor listening time
- 80-85 dB: Limit to 8 hours max
- Above 85 dB: Significant hearing risk

================================================================================
SUPPORT
================================================================================

GitHub: https://github.com/grisys83/APO-Loudness
License: GPLv3

================================================================================