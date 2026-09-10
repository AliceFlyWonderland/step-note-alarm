import 'package:flutter/material.dart';
import '../models/lyrics_data.dart';
import '../models/routine_data.dart';
import '../theme.dart';

/// 가사 라인: 한 소절이 불리는 동안 계속 떠 있고, 하이라이트가 그 위를 가로지름 (노래방 와이프)
/// 전주(1~32박) 구간에는 다음 소절 예고만 표시.
/// 전체 너비를 사용하고 FittedBox로 자동 축소해 절대 잘리지 않도록 함.
class LyricWipeLine extends StatelessWidget {
  final double exactBeat;

  const LyricWipeLine({super.key, required this.exactBeat});

  @override
  Widget build(BuildContext context) {
    final beat = exactBeat.floor().clamp(1, kTotalBeats);
    final line = lyricLineAtBeat(beat);

    if (line == null) {
      final beatsUntil = firstLyricBeat - beat;
      return Container(
        height: 46,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ShuffleColors.panel,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          beat < firstLyricBeat ? '♪ 전주 — 보컬 시작까지 $beatsUntil박' : '',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.55),
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      );
    }

    final progress = lineProgress(line, exactBeat);

    return Container(
      height: 46,
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: ShuffleColors.panel,
        borderRadius: BorderRadius.circular(10),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 기본 텍스트(어두운 톤)
            Text(
              line.fullText,
              maxLines: 1,
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 28,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
            // 와이프 하이라이트 (ShaderMask로 좌->우 진행)
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: const [
                    ShuffleColors.wipeHighlight,
                    ShuffleColors.wipeHighlight,
                    Colors.transparent,
                    Colors.transparent,
                  ],
                  stops: [0.0, progress, progress, 1.0],
                ).createShader(bounds);
              },
              child: Text(
                line.fullText,
                maxLines: 1,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
