// 순수 함수 모음: 미디어 시간 <-> 박 번호 변환, 러너웨이 기하 계산
// player_controller.dart 에서 사용됨

import '../models/routine_data.dart';

/// 오디오 재생 시간(초, 싱크 오프셋 적용 후) -> 정확한 박 번호(1.0 시작, 소수 가능)
double beatFromSongTime(double songTimeSec) {
  return songTimeSec / kBeatDurationSec + 1.0;
}

/// 박 번호 -> 오디오 재생 시간(초)
double songTimeFromBeat(double beat) {
  return (beat - 1.0) * kBeatDurationSec;
}

/// 러너웨이에서 특정 미래 박(targetBeat)의 x 좌표 비율(0.0~1.0)을 계산.
/// judgmentFraction: 판정선의 x 위치 비율 (예: 0.15 = 좌측 15%)
/// beatsVisibleAhead: 판정선에서 화면 우측 끝까지 보여줄 박 수
/// deltaBeat < 0 이면 이미 지나간 박 (판정선 좌측으로 사라짐)
double runwayXFraction({
  required double currentBeat,
  required double targetBeat,
  required double judgmentFraction,
  required double beatsVisibleAhead,
}) {
  final delta = targetBeat - currentBeat;
  final t = delta / beatsVisibleAhead; // 0 = 판정선, 1 = 화면 우측 끝
  return judgmentFraction + t * (1.0 - judgmentFraction);
}

/// 판정선 펄스 강도(0.0~1.0): 매 박 경계에서 1.0으로 튀고 감쇠
double judgmentPulseIntensity(double currentBeat) {
  final frac = currentBeat - currentBeat.floorToDouble(); // 0~1, 박 시작 후 진행률
  // 박 시작 직후 강하게, 이후 빠르게 감쇠
  return (1.0 - frac).clamp(0.0, 1.0);
}

int clampBeat(int beat) => beat.clamp(1, kTotalBeats);

double clampBeatDouble(double beat) => beat.clamp(1.0, kTotalBeats.toDouble() + 0.999);

/// 메트로놈 박자 패턴: 마디(4박) 내에서 강박(꿍) 위치가 다름.
/// fourOnFirst: 꿍-짝-짝-짝 (1박만 강, 1/4 박자 느낌)
/// twoBeat: 꿍-짝-꿍-짝 (1,3박 강, 2/4 박자 느낌)
enum MetronomeAccentPattern { fourOnFirst, twoBeat }

String metronomePatternLabel(MetronomeAccentPattern p) {
  switch (p) {
    case MetronomeAccentPattern.fourOnFirst:
      return '꿍짝짝짝';
    case MetronomeAccentPattern.twoBeat:
      return '꿍짝꿍짝';
  }
}

bool isMetronomeAccentBeat(MetronomeAccentPattern p, int beat) {
  final pos = (beat - 1) % 4; // 0,1,2,3
  if (p == MetronomeAccentPattern.fourOnFirst) return pos == 0;
  return pos == 0 || pos == 2;
}
