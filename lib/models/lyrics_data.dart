// 가사 싱크 데이터 (노래방 와이프 하이라이트용)
// Part A(1~32박)는 전주로 보컬 없음.
// 각 라인은 여러 단어 조각(WordSpan)으로 나뉘고, 각 조각은 시작~종료 박자를 가진다.
// 진행 중인 박자에 따라 하이라이트가 조각 단위로 가로지르며 이동한다.

class WordSpan {
  final String text;
  final int startBeat;
  final int endBeat; // inclusive

  const WordSpan({
    required this.text,
    required this.startBeat,
    required this.endBeat,
  });
}

class LyricLine {
  final String partLabel; // "1절" / "후렴"
  final int lineStartBeat;
  final int lineEndBeat;
  final List<WordSpan> words;

  const LyricLine({
    required this.partLabel,
    required this.lineStartBeat,
    required this.lineEndBeat,
    required this.words,
  });

  String get fullText => words.map((w) => w.text).join(' ');
}

const List<LyricLine> lyricLines = [
  LyricLine(
    partLabel: '1절',
    lineStartBeat: 33,
    lineEndBeat: 40,
    words: [
      WordSpan(text: '나의 거리에는', startBeat: 33, endBeat: 36),
      WordSpan(text: '어둠이 또 밀리면', startBeat: 37, endBeat: 40),
    ],
  ),
  LyricLine(
    partLabel: '1절',
    lineStartBeat: 41,
    lineEndBeat: 48,
    words: [
      WordSpan(text: '하늘엔', startBeat: 41, endBeat: 44),
      WordSpan(text: '작은 별 하나', startBeat: 45, endBeat: 48),
    ],
  ),
  LyricLine(
    partLabel: '1절',
    lineStartBeat: 49,
    lineEndBeat: 56,
    words: [
      WordSpan(text: '그 길을 따라', startBeat: 49, endBeat: 52),
      WordSpan(text: '나 홀로 가니', startBeat: 53, endBeat: 56),
    ],
  ),
  LyricLine(
    partLabel: '1절',
    lineStartBeat: 57,
    lineEndBeat: 64,
    words: [
      WordSpan(text: '허전한', startBeat: 57, endBeat: 60),
      WordSpan(text: '발길뿐이네', startBeat: 61, endBeat: 64),
    ],
  ),
  LyricLine(
    partLabel: '후렴',
    lineStartBeat: 65,
    lineEndBeat: 78,
    words: [
      WordSpan(text: '바람아', startBeat: 65, endBeat: 68),
      WordSpan(text: '불어라', startBeat: 69, endBeat: 72),
      WordSpan(text: '(간주)', startBeat: 73, endBeat: 78),
    ],
  ),
  LyricLine(
    partLabel: '후렴',
    lineStartBeat: 79,
    lineEndBeat: 88,
    words: [
      WordSpan(text: '작은 나의', startBeat: 79, endBeat: 80),
      WordSpan(text: '두 뺨에', startBeat: 81, endBeat: 84),
      WordSpan(text: '(간주)', startBeat: 85, endBeat: 88),
    ],
  ),
  LyricLine(
    partLabel: '후렴',
    lineStartBeat: 89,
    lineEndBeat: 104,
    words: [
      WordSpan(text: '오 바람아 불어라', startBeat: 89, endBeat: 92),
      WordSpan(text: '작은 나의 가슴에', startBeat: 93, endBeat: 96),
      WordSpan(text: '(간주)', startBeat: 97, endBeat: 104),
    ],
  ),
  LyricLine(
    partLabel: '후렴',
    lineStartBeat: 105,
    lineEndBeat: 110,
    words: [
      WordSpan(text: '허전한 맘', startBeat: 105, endBeat: 108),
      WordSpan(text: '지우게', startBeat: 109, endBeat: 110),
    ],
  ),
];

/// 전주 구간(1~32박)에서 다음 소절이 몇 박부터 시작하는지 예고 표시용
const int firstLyricBeat = 33;

LyricLine? lyricLineAtBeat(int beat) {
  for (final l in lyricLines) {
    if (beat >= l.lineStartBeat && beat <= l.lineEndBeat) return l;
  }
  return null;
}

/// 현재 박자에서 활성화된 단어 인덱스(하이라이트 위치)
int activeWordIndex(LyricLine line, int beat) {
  for (int i = 0; i < line.words.length; i++) {
    if (beat >= line.words[i].startBeat && beat <= line.words[i].endBeat) {
      return i;
    }
  }
  return -1;
}

/// 라인 내 진행률(0.0~1.0) - 와이프 하이라이트 폭 계산용
double lineProgress(LyricLine line, double exactBeat) {
  final total = (line.lineEndBeat - line.lineStartBeat + 1).toDouble();
  final elapsed = exactBeat - line.lineStartBeat;
  return (elapsed / total).clamp(0.0, 1.0);
}
