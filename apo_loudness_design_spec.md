# ApoLoudness 설계 명세서

## 1. 프로젝트 개요

### 1.1 목적
ApoLoudness는 등청감 곡선(Equal Loudness Contour)을 기반으로 한 혁신적인 볼륨 조절 도구입니다. 기존 오디오 앱들과 달리 인간의 청각 특성을 고려하여 볼륨을 변경해도 음색 밸런스가 유지되도록 설계되었습니다.

### 1.2 핵심 개념
- **Target Phon**: 사용자가 원하는 목표 음량 레벨 (40-90 dB)
- **Reference Phon**: 기준 음량 레벨 (80-90 dB, 일반적으로 80dB 고정)
- **Offset**: 사용자 미세 조정값 (-20dB ~ +10dB)
- **Real dB SPL**: 실제 환경에서 측정되는 음압 레벨

### 1.3 기술적 특징
- Equalizer APO와 연동하여 실시간 오디오 처리
- 실측 데이터 기반의 정확한 음량 계산
- 직관적인 UI와 자동 조절 기능

## 2. 시스템 아키텍처

### 2.1 전체 구조
```
User Interface (Qt) ↔ ApoLoudness Core ↔ Equalizer APO
                                      ↔ Measurement Data
                                      ↔ Configuration Files
```

### 2.2 주요 컴포넌트

#### 2.2.1 UI 컴포넌트
- **MainWindow**: 메인 컨트롤 인터페이스 (400x60px)
- **ContextMenu**: 설정 및 옵션 메뉴
- **InfoDialog**: 현재 상태 및 도움말 표시

#### 2.2.2 Core 컴포넌트
- **LoudnessCalculator**: 등청감 곡선 계산 엔진
- **MeasurementProcessor**: 실측 데이터 처리
- **ConfigManager**: 설정 파일 관리
- **APOInterface**: Equalizer APO 연동

### 2.3 데이터 플로우
1. 사용자 입력 (휠 스크롤, 키 조합)
2. Target/Reference Phon 계산
3. 실측 데이터 기반 보정
4. Preamp 값 계산
5. Equalizer APO 설정 파일 업데이트
6. UI 상태 갱신

## 3. 측정 프로토콜 표준화

### 3.1 측정 환경 요구사항

#### 3.1.1 하드웨어
- **SPL 미터**: Class 1 또는 Class 2 사운드 레벨 미터
- **측정 마이크**: Z-weighted 측정 지원
- **오디오 인터페이스**: 고품질 DAC/ADC (최소 24bit/48kHz)

#### 3.1.2 소프트웨어
- **Equalizer APO**: 실시간 오디오 처리
- **테스트 신호**: Pink Noise 또는 Warble Tone
- **측정 소프트웨어**: REW (Room EQ Wizard) 권장

### 3.2 측정 절차

#### 3.2.1 스피커 측정
1. **환경 설정**
   - 조용한 환경 (배경소음 < 30dB SPL)
   - 청취 위치에서 측정 (일반적으로 1-3m 거리)
   - 마이크는 귀 높이에 위치

2. **기준점 설정**
   - Reference Phon 80dB로 고정
   - Pink Noise 재생
   - SPL 미터로 실제 음압 측정

3. **Target Phon별 측정**
   ```
   Target 40 → Preamp 조정 → 실측 dB SPL 기록
   Target 50 → Preamp 조정 → 실측 dB SPL 기록
   Target 60 → Preamp 조정 → 실측 dB SPL 기록
   Target 70 → Preamp 조정 → 실측 dB SPL 기록
   Target 80 → Preamp 조정 → 실측 dB SPL 기록
   ```

4. **Offset 검증**
   ```
   각 Target에서 Offset +5dB 적용 → 실측치 비교
   ```

#### 3.2.2 헤드폰 측정
1. **HRTF 보정**
   - 헤드폰 전용 보정 곡선 적용
   - 인공 귀(Artificial Ear) 또는 더미 헤드 사용 권장

2. **개인별 보정**
   - 개인의 청각 특성 고려
   - 주관적 등청감 테스트 병행

### 3.3 측정 데이터 형식
```cpp
const QMap<double, double> measuredTargetToDbSpl = {
    {40.0, measured_value_40},  // Target 40dB → 실측 SPL
    {50.0, measured_value_50},  // Target 50dB → 실측 SPL
    {60.0, measured_value_60},  // Target 60dB → 실측 SPL
    {70.0, measured_value_70},  // Target 70dB → 실측 SPL
    {80.0, measured_value_80}   // Target 80dB → 실측 SPL
};
```

## 4. 사용 환경별 가이드라인

### 4.1 스피커 시스템
- **권장 환경**: 2채널 스테레오, 근접장 모니터
- **측정 위치**: 스위트 스팟(sweet spot)
- **주의사항**: 룸 어쿠스틱 영향 고려

### 4.2 헤드폰 시스템
- **권장 타입**: 개방형 또는 밀폐형 헤드폰
- **보정 필요**: 헤드폰별 주파수 응답 특성
- **개인차**: 귀 모양, 착용감에 따른 차이

### 4.3 환경별 프로파일
```cpp
enum AudioEnvironment {
    SPEAKER_NEARFIELD,    // 근접장 스피커
    SPEAKER_FARFIELD,     // 원거리장 스피커
    HEADPHONE_OPEN,       // 개방형 헤드폰
    HEADPHONE_CLOSED,     // 밀폐형 헤드폰
    HEADPHONE_IEM         // 인이어 모니터
};
```

## 5. 소프트웨어 설계

### 5.1 클래스 구조

#### 5.1.1 MainWindow
```cpp
class MainWindow : public QMainWindow {
    // UI 관리 및 사용자 입력 처리
    // Equalizer APO 설정 파일 생성
    // 실시간 상태 표시
};
```

#### 5.1.2 LoudnessProcessor
```cpp
class LoudnessProcessor {
    static double calculateOffsetEffect(double base, double offset);
    static double calculateRealDbSpl(double target, double base, double offset);
    static double interpolateDbSpl(const QMap<double, double>& data, double value);
};
```

### 5.2 핵심 알고리즘

#### 5.2.1 등청감 보정 계산
```cpp
// Offset 효과를 dB로 변환
double offsetEffect = 20.0 * log10(offsetRange / baseRange);

// 최종 실제 음압 레벨
double realDbSpl = baseDbSpl + offsetEffect;
```

#### 5.2.2 선형 보간
```cpp
// Target Phon 중간값에 대한 선형 보간
double interpolatedValue = y1 + (y2 - y1) * (x - x1) / (x2 - x1);
```

### 5.3 사용자 인터페이스

#### 5.3.1 컨트롤 매핑
- **기본 휠**: Offset 조절 (-20dB ~ +10dB)
- **Ctrl + 휠**: Target Phon 조절 (40-90dB)
- **Alt + 휠**: Reference Phon 조절 (80-90dB)
- **우클릭**: 컨텍스트 메뉴
- **더블클릭**: 기본값 리셋

#### 5.3.2 Auto Offset 모드
```cpp
if (isAutoOffset) {
    // Target과 Real dB SPL이 연동되어 조절
    targetPhonValue += delta;
    preampUserOffset += compensationValue;
}
```

## 6. 설정 파일 형식

### 6.1 Equalizer APO 출력
```
Preamp: -15.6 dB
Convolution: Filters/60.0-80.0_filter.wav
```

### 6.2 측정 데이터 설정
```ini
[MeasurementData]
Environment=SPEAKER_NEARFIELD
Target40=59.3
Target50=65.4
Target60=71.8
Target70=77.7
Target80=83.0
```

## 7. 배포 및 오픈소스 고려사항

### 7.1 라이선스
- **권장**: MIT 또는 GPL v3
- **종속성**: Qt 라이선스 호환성 확인

### 7.2 문서화 요구사항
- 설치 가이드
- 측정 절차 매뉴얼
- 사용 환경별 설정 가이드
- API 문서

### 7.3 표준화 제안
- 측정 프로토콜 RFC 문서 작성
- 오디오파일 커뮤니티 검토
- 헤드폰/스피커 제조사 협력

### 7.4 확장성 고려
- 플러그인 아키텍처
- 다양한 오디오 엔진 지원 (VST, ASIO)
- 클라우드 기반 측정 데이터 공유

## 8. 향후 개발 로드맵

### 8.1 Phase 1: Core Release
- [ ] 기본 기능 완성
- [ ] 측정 프로토콜 문서화
- [ ] 오픈소스 릴리즈

### 8.2 Phase 2: Enhancement
- [ ] 자동 측정 도구 개발
- [ ] 다양한 환경 프로파일 추가
- [ ] 커뮤니티 측정 데이터 수집

### 8.3 Phase 3: Integration
- [ ] 타 오디오 소프트웨어 연동
- [ ] 모바일 버전 개발
- [ ] 클라우드 서비스 제공

---

*이 명세서는 ApoLoudness 프로젝트의 오픈소스 공개를 위한 기술 문서입니다. 커뮤니티 피드백과 기여를 환영합니다.*