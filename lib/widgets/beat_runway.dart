import 'package:flutter/material.dart';
import '../models/routine_data.dart';
import '../services/beat_clock.dart';
import '../theme.dart';

/// 비트 러너웨이: 노트가 오른쪽에서 왼쪽으로 흘러 판정선에 닿는 순간이 그 박.
/// 판정선은 매 박 맥동. 사각형=스텝 시작 박, 크기/밝기=강·중·약박.
class BeatRunway extends StatelessWidget {
  final double exactBeat;
  static const double judgmentFraction = 0.14;
  static const double beatsVisibleAhead = 10.0;

  const BeatRunway({super.key, required this.exactBeat});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        final pulse = judgmentPulseIntensity(exactBeat);

        final firstBeat = exactBeat.floor() - 1;
        final lastBeat = (exactBeat + beatsVisibleAhead).ceil();

        final notes = <Widget>[];
        for (int b = firstBeat.clamp(1, kTotalBeats); b <= lastBeat.clamp(1, kTotalBeats); b++) {
          final x = runwayXFraction(
            currentBeat: exactBeat,
            targetBeat: b.toDouble(),
            judgmentFraction: judgmentFraction,
            beatsVisibleAhead: beatsVisibleAhead,
          );
          if (x < -0.05 || x > 1.05) continue;

          final strength = beatStrengthOf(b);
          final isStepStart = routineSteps.any((s) => s.startBeat == b);

          double size;
          double opacity;
          switch (strength) {
            case BeatStrength.strong:
              size = 26;
              opacity = 1.0;
              break;
            case BeatStrength.medium:
              size = 19;
              opacity = 0.75;
              break;
            case BeatStrength.weak:
              size = 14;
              opacity = 0.5;
              break;
          }

          final isPast = b < exactBeat.floor();
          if (isPast) opacity *= 0.25;

          notes.add(Positioned(
            left: x * w - size / 2,
            top: h / 2 - size / 2,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: opacity),
                shape: isStepStart ? BoxShape.rectangle : BoxShape.circle,
                borderRadius: isStepStart ? BorderRadius.circular(4) : null,
                boxShadow: isStepStart
                    ? [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: opacity * 0.6),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
            ),
          ));
        }

        return Container(
          decoration: BoxDecoration(
            color: ShuffleColors.panel,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                // 트랙 라인
                Positioned(
                  top: h / 2 - 1,
                  left: 0,
                  right: 0,
                  child: Container(height: 2, color: Colors.white12),
                ),
                ...notes,
                // 판정선
                Positioned(
                  left: judgmentFraction * w - 2,
                  top: 6,
                  bottom: 6,
                  child: Container(
                    width: 4,
                    decoration: BoxDecoration(
                      color: Color.lerp(ShuffleColors.accent, Colors.white,
                          pulse * 0.8),
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          color: ShuffleColors.judgment
                              .withValues(alpha: 0.3 + pulse * 0.5),
                          blurRadius: 6 + pulse * 14,
                          spreadRadius: pulse * 3,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
