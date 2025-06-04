# ApoLoudness: DSP 기술 설명서

## 개요

ApoLoudness는 ISO 226:2003 등청감 곡선을 기반으로 한 실시간 라우드니스 보상 시스템입니다. 다양한 재생 레벨에서 일관된 음색 밸런스를 유지하기 위해 주파수 응답을 동적으로 조정합니다.

## 핵심 DSP 개념

### 문제점
인간의 청각은 SPL(음압 레벨)에 따라 주파수별 감도가 다르게 나타납니다. 낮은 볼륨에서:
- 저음 주파수(< 200 Hz)가 현저히 조용하게 들림
- 고음 주파수(> 5 kHz)도 감쇄됨
- 중음역(1-5 kHz)은 상대적으로 안정적

이로 인해 낮은 볼륨에서 소리가 "얇고" "생기없게" 들립니다.

### 해결책
청각의 비선형성을 보상하기 위해 역 등청감 곡선 필터링을 적용합니다.

## 신호 처리 체인

```
입력 오디오 → 프리앰프 게인 → 컨볼루션 (FIR 필터) → 출력 오디오
                 ↑                    ↑
                 |                    |
            사용자 제어         사전 계산된 필터
           (Target/Offset)      (ISO 226 기반)
```

## 주요 구성요소

### 1. FIR 필터 뱅크
- **형식**: 44.1/48 kHz에서 16384-tap FIR 필터
- **범위**: 모든 Target/Reference 쌍 조합 (40-90 phon)
- **설계**: 등청감 곡선 간 차이의 역함수

예시: Target=60, Reference=80인 경우:
```
H(f) = L80(f) - L60(f)
```
여기서 L(f)는 dB 단위의 등청감 곡선을 나타냅니다.

### 2. 프리앰프 계산
시스템은 2단계 게인 구조를 사용합니다:

```
총 게인 = 기본 프리앰프 + 사용자 오프셋
```

- **기본 프리앰프**: 곡선 간 라우드니스 차이를 정규화
- **사용자 오프셋**: 실제 재생 레벨 미세 조정

### 3. 실제 SPL 추정
알고리즘은 캘리브레이션 데이터를 사용해 귀에서의 실제 SPL을 추정합니다:

```python
def calculate_real_spl(target_phon, reference_phon, base_preamp, actual_preamp):
    # 이 target/reference 쌍에 대한 캘리브레이션된 기본 SPL 가져오기
    base_spl = calibration_lookup[(reference_phon, target_phon)]
    
    # 오프셋 효과 계산
    offset_db = actual_preamp - base_preamp
    offset_effect = calculate_psychoacoustic_offset(offset_db)
    
    return base_spl + offset_effect
```

## DSP 알고리즘 흐름

### 1. 사용자 입력 처리
```
마우스 휠 → Target SPL 요청 → 최적 파라미터 찾기
```

### 2. Auto Offset 모드 (v0.3.5 개선사항)
```python
def auto_offset_algorithm(current_real_spl, reference_level):
    target_real_spl = user_requested_spl
    
    if target_real_spl <= reference_level:
        # 톤 밸런스 보정을 위해 reference 유지
        reference = reference_level
    else:
        # 자연스러운 밸런스 유지를 위해 reference 조정
        reference = round(target_real_spl)
    
    # Real SPL = Target이 되는 최적 offset 계산
    offset = find_offset_for_target_spl(target_real_spl, reference)
    
    return reference, target_real_spl, offset
```

### 3. 필터 선택
```python
def select_filter(target_phon, reference_phon):
    # 가장 가까운 사용 가능한 필터로 반올림
    target_rounded = round(target_phon, 1)
    reference_rounded = round(reference_phon)
    
    # 파일명 구성
    filter_path = f"{sample_rate}/{target_rounded}-{reference_rounded}_filter.wav"
    
    return filter_path
```

## 심리음향학적 고려사항

### 1. 라우드니스 vs 볼륨
- **볼륨**: 물리적 진폭/게인 조정
- **라우드니스**: 지각적 양 (phon/sone)
- **실제 SPL**: 고막에서의 캘리브레이션된 압력

### 2. 등청감 보상 전략
- **80 dB SPL 이하**: 완전한 보상을 위한 역 곡선 적용
- **80 dB SPL 이상**: 다이나믹스 보존을 위해 점진적으로 보상 감소
- **Reference 유연성**: 장르별 최적화를 위한 75-90 phon 허용

### 3. 오프셋 심리음향학
오프셋이 SPL로 선형 변환되지 않는 이유:
- 주파수 가중 라우드니스 합산
- 비선형 와우각 압축
- 양이 라우드니스 합산

경험적 공식:
```
SPL_change ≈ 20 * log10((preamp + 40) * 2.5 / (base + 40) * 2.5)
```

## 구현 세부사항

### 1. 컨볼루션 엔진
- Equalizer APO의 네이티브 컨볼루션 프로세서 사용
- 제로 레이턴시 파티션 컨볼루션
- 32비트 부동소수점 처리

### 2. 설정 형식
```
Preamp: -15.6 dB
Convolution: ../Filters/48000/60.0-80.0_filter.wav
```

### 3. 실시간 업데이트
- Equalizer APO의 설정 파일 모니터링
- 글리치 방지를 위한 원자적 파일 쓰기
- < 100ms 업데이트 레이턴시

## 캘리브레이션 시스템

### 목적
정확한 레벨 추정을 위한 (Reference, Target, Preamp) → Real SPL 매핑

### 방법
1. 알려진 설정에서 핑크 노이즈 생성
2. 캘리브레이션된 미터로 SPL 측정
3. 보간 테이블 구축
4. 심리음향학적 오프셋 모델 적용

## 성능 고려사항

### CPU 사용량
- 컨볼루션: ~1-3% CPU (최신 시스템)
- UI 업데이트: 무시할 수준
- 파일 I/O: 원자적 쓰기, 오디오 스레드 차단 없음

### 메모리
- 각 FIR 필터: ~128 KB
- 전체 필터 뱅크: 샘플레이트당 ~15 MB
- 런타임: UI 포함 < 10 MB

## 향후 DSP 개선사항

1. **동적 필터 보간**: 필터 간 부드러운 전환
2. **멀티밴드 다이나믹스**: 주파수별 압축
3. **룸 보정 통합**: 룸 EQ와 결합
4. **바이노럴 모델**: 좌/우 귀 차이
5. **실시간 캘리브레이션**: 마이크 피드백 사용

## 수학적 기초

핵심 등청감 곡선 방정식 (ISO 226:2003):

```
Lp = 10/α_f * log10(α_f * (p/p_0)^2 * 10^(α_f*L_U/10) / (1 + k * (p/p_0)^2)) - L_U + 94
```

여기서:
- Lp: 음압 레벨 (dB)
- L_U: 라우드니스 레벨 (phon)
- α_f, T_f, L_U: 주파수 의존 파라미터
- p/p_0: 압력 비율

이것을 역산하고 차분하여 보상 곡선을 만듭니다.

## 결론

ApoLoudness는 이론적 정확성과 실제 사용성의 균형을 맞춘 심리음향학적 라우드니스 보상의 실용적 구현입니다. v0.3.5의 유연한 reference 레벨 개선은 장르별 최적화를 가능하게 하면서도 핵심 원칙을 유지합니다: 재생 레벨에 관계없이 일관된 지각적 음색 밸런스.

구현에 관심 있는 DSP 엔지니어를 위한 핵심 통찰: 지각적 라우드니스 보상은 단순한 주파수 의존 게인뿐만 아니라, 그 게인 구조의 레벨 의존적 적응도 필요합니다. 과제는 이를 최소한의 레이턴시와 CPU 사용량으로 사용자 친화적인 실시간 시스템으로 구현하는 것입니다.