<<<<<<< HEAD
# APO-Loudness
Equalizer APO Loudness control using FIR filters from FIR-Filter-Maker <https://github.com/grisys83/FIR-Filter-Maker-for-Equal-Loudness>

## Installation & Operation
1. Install Equalizer APO.
2. Extract the compressed file to C:\Program Files\ApoLoudness.
3. Open C:\Program Files\EqualizerAPO\config\config.txt with Notepad and add the following line at the end:
```
Include: Loudness.txt
```
5. Copy .WAV files created by FIR-Filter-Maker-for-Equal-Loudness to C:\Program Files\EqualizerAPO\config.
6. Create Loudness.txt in C:\Program Files\EqualizerAPO\config with the following content:
```
Preamp: -23 dB
Convolution: 60.0-85.0_filter.wav
```
6. Run C:\Program Files\ApoLoudness\ApoLoudness.exe

## Usage
The current volume is displayed in a small always-on-top window on the screen.

With the mouse cursor over the app's window, scroll the mouse wheel while holding the right button to adjust the volume (front number) in 0.1dB increments. The corresponding FIR filter will be applied based on the volume.

Holding the right mouse button and clicking the left button cycles through target loudness levels (back number) from 80.0 to 90.0. (We recommend using 85, but feel free to choose according to your preference.)

Double-clicking the left mouse button resets to 60.0-80.0 dB.

## Principles

### Purpose of Hundreds of WAV Files by FIR-Filter-Maker
These are FIR filters that adjust EQ based on the relative sound level differences between 80-90 phon and 60-90 phon equal-loudness contours.

### Function of the App.
Right-clicking and scrolling the mouse wheel adjusts the content of loudness.txt according to the volume. The front number represents the current loudness curve (volume), and the back number represents the target loudness curve (tone balance).

Note: The Harman target is reportedly based on the free field target of 85dB.

### For More Accurate Usage (In Case of 85 Phon Target)
1. Use a 1 kHz 0 dB sound source for this purpose. You can find an appropriate sound source here: <https://www.youtube.com/watch?v=-GvBJNRqEEw>
2. Set the configuration to "85.0-85.0" in the application.
3. Adjust the amplifier's volume until a decibel meter reads 85.0 dB.
=======
# ApoLoudness

ApoLoudness는 사용자에게 권장 프리앰프 값을 제공하여 적절한 음량 설정을 돕는 Qt 기반 데스크톱 애플리케이션입니다.

## 주요 기능

*   **프리앰프 값 추천**: 사용자가 설정한 기준 음량(Reference Phon)과 목표 음량(Target Phon)에 따라 권장 프리앰프(Preamp) 값을 제시합니다.
*   **사용자 조정**: 제시된 프리앰프 값에서 사용자가 직접 미세 조정을 할 수 있습니다.
*   **설정 저장 및 불러오기**: 사용자가 설정한 값들을 로컬 설정 파일(`config.ini`)에 저장하고, 프로그램 실행 시 다시 불러옵니다.
*   **직관적인 UI**: 현재 설정된 음량 값과 프리앰프 값을 명확하게 표시하며, 마우스 휠과 드래그를 통해 값을 쉽게 변경할 수 있도록 지원합니다.
    *   마우스 휠: 목표 음량(Target Phon) 값을 0.1 단위로 변경합니다.
    *   마우스 좌클릭 드래그: 창을 이동합니다.
    *   마우스 우클릭 또는 더블 클릭: 기준 음량(Reference Phon) 값을 순환하며 변경합니다.

## 기술 스택

*   C++
*   Qt (Core, Gui, Widgets)

## 빌드 방법

1.  Qt Creator 또는 Qt SDK가 설치된 환경이 필요합니다.
2.  `ApoLoudness.pro` 파일을 Qt Creator로 엽니다.
3.  프로젝트를 빌드합니다.

## 설정 파일

*   `config.ini`: 프로그램 실행 폴더에 생성되며, 다음과 같은 정보를 저장합니다.
    *   `LoudnessIndex`: 마지막으로 선택된 기준 음량(Reference Phon)의 인덱스
    *   `TargetPhonValue`: 마지막으로 설정된 목표 음량(Target Phon) 값
    *   `PreampUserOffset`: 사용자가 조정한 프리앰프 오프셋 값
    *   `WindowPositionX`, `WindowPositionY`: 프로그램 창의 마지막 위치

## 참고

*   프로그램의 핵심 로직은 `mainwindow.cpp`에 구현되어 있으며, 미리 계산된 프리앰프 값 테이블(`recommendedPreampMap`)을 사용하여 사용자에게 적절한 값을 추천합니다.
*   UI는 `mainwindow.ui` 파일을 통해 디자인되었으며, `mainwindow.h` 와 `mainwindow.cpp`에서 해당 UI 요소들을 제어합니다. 
>>>>>>> 77fc216 (Update README.md, add .gitignore, and prepare for v0.2)
