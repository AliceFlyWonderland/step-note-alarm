# 🕺 Shuffle Beat — 셔플 스텝노트 알리미

> 구창모 「방황」 셔플댄스 루틴을 위한 **박자 동기화 스텝노트 프리뷰 앱**
> 테트리스의 "다음 블록"처럼, 다가올 스텝을 미리 큼직하게 보여주는 연습용 프로토타입입니다.

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.35.4-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-3.9.2-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20Web-3DDC84?style=for-the-badge&logo=android&logoColor=white" alt="Platform" />
  <img src="https://img.shields.io/badge/Material%20Design-3-757575?style=for-the-badge&logo=materialdesign&logoColor=white" alt="Material Design 3" />
</p>

<p align="center">
  <img src="https://img.shields.io/badge/State%20Management-Provider-6C7CFF?style=flat-square" alt="Provider" />
  <img src="https://img.shields.io/badge/Audio-audioplayers-FF8A3D?style=flat-square" alt="audioplayers" />
  <img src="https://img.shields.io/badge/File%20I%2FO-file_picker-23D5D5?style=flat-square" alt="file_picker" />
  <img src="https://img.shields.io/badge/Local%20Storage-shared_preferences-FFE066?style=flat-square&logoColor=black" alt="shared_preferences" />
  <img src="https://img.shields.io/badge/License-Private-lightgrey?style=flat-square" alt="License" />
</p>

---

## 📖 프로젝트 소개

**Shuffle Beat**는 셔플댄스 연습생을 위해 만든 "빠른 프로토타이핑" 앱입니다.
구창모의 「방황」(128 BPM, 4/4박자, 총 110박) 안무를 대상으로,
- 정확한 박자 타임라인 위에서
- 가사와 싱크된 카라오케식 하이라이트를 보여주고
- **지금 밟아야 할 스텝**과 **다음에 나올 스텝(Next Preview)**을 테트리스 다음 블록처럼 미리 보여줍니다.

먼 거리에서도 스텝명을 읽을 수 있도록 큰 글씨를 사용하며, 이름이 너무 길어 화면에 다 담기지 않을 경우 대한셔플댄스협회 표준 약칭(예: 러닝맨 → `RM`)으로 자동 대체합니다.

---

## ✨ 주요 기능

### 🎵 박자 엔진 (Beat Engine)
- **Single Source of Truth 설계**: 모든 박자 위치(`exactBeat`)는 항상 경과된 음악 시간(`songTimeSec`)으로부터 재계산되어, 별도 스케줄러 상태와 어긋날 여지가 없습니다.
- 128 BPM 기준 1박 = `0.46875초`, 총 110박을 Part A(전주/인트로, 1~32박) · Part B(1절, 33~64박) · Part C(코러스 클라이맥스, 65~110박)로 구성.
- 오디오 파일이 로드된 경우 실제 재생 위치로 주기적 보정, 없을 경우 메트로놈 모드로 로컬 타이머 기반 진행.

### 🕺 스텝노트 프리뷰 (Tetris-style Next Block)
- 현재 스텝명을 초대형 폰트로 중앙에 표시 (박자 진행 도트 + 동작 가이드 텍스트 포함)
- 화면 하단에 **다음 스텝 미리보기(NEXT)** 카드를 배치, 스텝 전환 시점에 강조 애니메이션
- 스텝명이 길 경우 약칭으로 자동 축소 표시 (예: `MRM`, `킥볼체인지`, `T앞뒤` 등 25종 스텝 분류 체계 반영)

### 🎤 가사 카라오케 와이프 (Lyric Wipe Sync)
- `ShaderMask` + `LinearGradient` 기반으로 현재 재생 위치에 맞춰 가사가 좌→우로 하이라이트되는 노래방식 효과
- 전주 구간에서는 "보컬 시작까지 N박" 카운트다운 안내
- `FittedBox`로 긴 가사 줄도 잘리지 않고 자동 축소되어 항상 보이도록 처리

### 🏃 비트 러너웨이 (Beat Runway)
- 리듬게임 노트 레인처럼 다가오는 박자를 판정선을 향해 흘려보내는 시각화
- 강박/중박/약박(`BeatStrength`)에 따라 노트 크기·밝기 차등, 판정선 펄스 이펙트

### 🥁 메트로놈 (Metronome)
- **기본값 ON** — 실제 음원이 연결되어 있어도 클릭음을 오버레이로 재생 가능
- 박자 패턴 2종 선택 지원:
  - **꿍짝짝짝** (`fourOnFirst`) — 1박만 강박, 4박자 느낌
  - **꿍짝꿍짝** (`twoBeat`) — 1·3박 강박, 2박자 느낌
- 강박(꿍)/약박(짝) 전용 사운드 이펙트 분리 재생

### 🎯 연습 보조 기능
- **드릴 구간 반복 재생**: 특정 박자 구간을 선택해 반복 루프
- **거울 모드(Mirror)**: 좌/우 발 라벨을 반전시켜 마주 보고 연습 가능
- **재생 속도 조절**: 50%~150% 범위에서 5% 단위 조절
- **8박 리드인 카운트**: "준비×4 → 4·3·2·1" 카운트다운 후 본 재생 시작
- **음원 싱크 보정**: 사용자가 직접 음원 파일을 불러와 ±0.1초 단위로 싱크 오프셋 조정 가능

---

## 🛠 기술 스택

| 영역 | 기술 |
|---|---|
| **프레임워크** | Flutter 3.35.4 / Dart 3.9.2 |
| **상태 관리** | Provider (`ChangeNotifier` + `MultiProvider`) |
| **오디오 재생** | `audioplayers` — 음원 재생 + 메트로놈 클릭음 오버레이 |
| **파일 선택** | `file_picker` — 사용자 음원 파일 로드 |
| **로컬 저장** | `shared_preferences` — 싱크 오프셋 등 설정 값 영속화 |
| **UI 디자인** | Material Design 3, 다크 테마 커스텀 (`ShuffleColors`) |
| **배포/미리보기** | Flutter Web (release build) + Python HTTP Server |
| **타겟 플랫폼** | Android 태블릿 가로모드 (1차), Web (프로토타입 미리보기) |

---

## 📁 프로젝트 구조

```
lib/
├── main.dart                    # 앱 진입점, MultiProvider 설정, 가로모드 고정
├── theme.dart                   # ShuffleColors 팔레트 + Material3 다크 테마
├── models/
│   ├── routine_data.dart        # 110박 타임라인, 32개 RoutineStep, BeatCue, BeatStrength
│   └── lyrics_data.dart         # 가사 라인 8개, 카라오케 진행률 계산 헬퍼
├── services/
│   ├── beat_clock.dart          # 박자<->시간 변환 순수 함수, 메트로놈 패턴 로직
│   ├── audio_source_service.dart # 음원 파일 로드 + 싱크 오프셋 영속화
│   └── player_controller.dart   # 재생 상태 단일 소유자 (리드인/드릴/속도/거울/메트로놈)
├── widgets/
│   ├── lyric_wipe_line.dart      # 카라오케 와이프 가사 줄
│   ├── step_display.dart         # 현재 스텝 대형 표시 + 다음 스텝 프리뷰
│   ├── beat_runway.dart          # 리듬게임식 비트 러너웨이
│   ├── progress_bar.dart         # 전체 진행 바 + 난이도 히트맵 + 드릴 구간 표시
│   ├── control_panel.dart        # 재생/속도/드릴/거울 컨트롤
│   ├── sync_panel.dart           # 음원 로드 + 싱크 보정 다이얼로그
│   └── metronome_panel.dart      # 메트로놈 ON/OFF + 박자 패턴 선택 다이얼로그
└── screens/
    └── home_screen.dart          # 전체 화면 레이아웃 조립

assets/
└── audio/
    ├── click.mp3                 # 레거시 클릭음 (리드인 폴백)
    ├── kung.mp3                   # 강박(꿍) 사운드
    └── jjak.mp3                   # 약박(짝) 사운드
```

---

## 🎼 안무 데이터 출처

- **곡**: 구창모 「방황」
- **BPM / 박자**: 128 BPM, 4/4박자, E Major
- **총 박자 수**: 110박 (Part A: 1~32 / Part B: 33~64 / Part C: 65~110)
- **스텝 분류 체계**: 대한셔플댄스협회 표준 25종 스텝 + 약칭 글로서리 기반
- 원본 안무 문서(타임코드·발동작·음악 큐·가사 싱크 포인트 전체 포함)를 분석하여 `routine_data.dart`, `lyrics_data.dart`로 구조화했습니다.

---

## 🚀 실행 방법

### 사전 요구사항
- Flutter SDK 3.35.4 (Dart 3.9.2)

### 의존성 설치
```bash
flutter pub get
```

### 웹 미리보기 (release 빌드)
```bash
flutter build web --release
python3 -m http.server 5060 --directory build/web --bind 0.0.0.0
```

### Android APK 빌드
```bash
flutter build apk --release
```

### 정적 분석
```bash
flutter analyze
```

---

## 📌 개발 현황 (Status)

- ✅ 단일 곡("방황") 대상 프로토타입 — 박자 동기화, 가사 와이프, 스텝노트 프리뷰 구현 완료
- ✅ 메트로놈 기본 ON + 박자 패턴(꿍짝짝짝 / 꿍짝꿍짝) 선택 기능
- ✅ 드릴 반복 · 거울 모드 · 속도 조절 · 음원 싱크 보정
- 🔜 다곡 지원, iOS 대응, 실기기 태블릿 QA는 추후 로드맵

---

## 📄 라이선스

이 프로젝트는 비공개(Private) 프로토타입으로, 대한셔플댄스협회 표준 안무 데이터를 참고하여 개인 연습 목적으로 제작되었습니다.
