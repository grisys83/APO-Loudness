# APO-Loudness
Equalizer APO Loudness control using FIR filters from FIR-Filter-Maker <https://github.com/grisys83/FIR-Filter-Maker-for-Equal-Loudness>

## Installation & Operation
1. Install Equalizer APO.
2. Extract the compressed file to C:\Program Files\ApoLoudness.
3. Open C:\Program Files\EqualizerAPO\config\config.txt with Notepad and add the following line at the end: Include: Loudness.txt
4. Copy .WAV files created by FIR-Filter-Maker-for-Equal-Loudness to C:\Program Files\EqualizerAPO\config.
5. Create Loudness.txt in C:\Program Files\EqualizerAPO\config with the following content:
```
Preamp: -23 dB
Convolution: 60.0-85.0_filter.wav
```
6. Run C:\Program Files\ApoLoudness\ApoLoudness.exe

## Usage
The current volume is displayed in a small always-on-top window on the screen.

With the mouse cursor over this window, scroll the mouse wheel while holding the right button to adjust the volume (front number) in 0.1dB increments. The corresponding FIR filter will be applied based on the volume.

Holding the right mouse button and clicking the left button cycles through target loudness levels (back number) from 80.0 to 90.0. (We recommend using 85, but feel free to choose according to your preference.)

Double-clicking the left mouse button resets to 60.0/80.0 dB.

## Principles

### Purpose of Hundreds of WAV Files by FIR-Filter-Maker
These are FIR filters that adjust EQ based on the relative sound level differences between 80-90 phon and 60-90 phon equal-loudness contours.

### Function of the Script File
Right-clicking and scrolling the mouse wheel adjusts the content of loudness.txt according to the volume. The front number represents the current loudness curve (volume), and the back number represents the target loudness curve (tone balance).

Note: The Harman target is reportedly based on the free field target of 85dB.

### For More Accurate Usage (In Case of 85 Phon Target)
1. Use a 1 kHz 0 dB sound source for this purpose. You can find an appropriate sound source here: <https://www.youtube.com/watch?v=-GvBJNRqEEw>
2. Set the configuration to "85.0-85.0" in the application.
3. Adjust the amplifier's volume until a decibel meter reads 85.0 dB.
