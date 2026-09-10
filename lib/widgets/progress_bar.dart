import 'package:flutter/material.dart';
import '../models/routine_data.dart';
import '../theme.dart';

/// 진행 바: 110박 전체 위치. 눌러서 이동. 아래 띠는 난이도 히트맵.
class RoutineProgressBar extends StatelessWidget {
  final double exactBeat;
  final int? drillStart;
  final int? drillEnd;
  final void Function(int beat) onSeek;

  const RoutineProgressBar({
    super.key,
    required this.exactBeat,
    required this.onSeek,
    this.drillStart,
    this.drillEnd,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;

      void handleTap(double dx) {
        final ratio = (dx / w).clamp(0.0, 1.0);
        var beat = (ratio * kTotalBeats).round().clamp(1, kTotalBeats);
        if (drillStart != null && drillEnd != null) {
          beat = beat.clamp(drillStart!, drillEnd!);
        }
        onSeek(beat);
      }

      return GestureDetector(
        onTapDown: (d) => handleTap(d.localPosition.dx),
        onHorizontalDragUpdate: (d) => handleTap(d.localPosition.dx),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 메인 진행 트랙
            SizedBox(
              height: 22,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  // Part 구간 구분
                  Positioned(
                    left: (32 / kTotalBeats) * w,
                    top: 0,
                    bottom: 0,
                    child: Container(width: 1, color: Colors.white24),
                  ),
                  Positioned(
                    left: (64 / kTotalBeats) * w,
                    top: 0,
                    bottom: 0,
                    child: Container(width: 1, color: Colors.white24),
                  ),
                  // 드릴 구간 표시
                  if (drillStart != null && drillEnd != null)
                    Positioned(
                      left: ((drillStart! - 1) / kTotalBeats) * w,
                      width: ((drillEnd! - drillStart! + 1) / kTotalBeats) * w,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: ShuffleColors.accent.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: ShuffleColors.accent, width: 1.5),
                        ),
                      ),
                    ),
                  // 진행률 채움
                  Container(
                    width: (exactBeat / kTotalBeats) * w,
                    decoration: BoxDecoration(
                      color: ShuffleColors.accent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  // 현재 위치 핸들
                  Positioned(
                    left: ((exactBeat / kTotalBeats) * w - 3).clamp(0, w - 6),
                    top: -3,
                    bottom: -3,
                    child: Container(
                      width: 6,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3),
                        boxShadow: const [
                          BoxShadow(color: Colors.black54, blurRadius: 4),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            // 난이도 히트맵
            SizedBox(
              height: 10,
              child: Row(
                children: List.generate(kTotalBeats, (i) {
                  final beat = i + 1;
                  final step = stepAtBeat(beat);
                  final diff = step?.difficulty ?? 1;
                  final color = Color.lerp(
                    const Color(0xFF2E7D32),
                    const Color(0xFFD32F2F),
                    (diff - 1) / 4.0,
                  );
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 0.3),
                      color: color,
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Part A', style: TextStyle(color: ShuffleColors.textDim, fontSize: 11)),
                Text('Part B', style: TextStyle(color: ShuffleColors.textDim, fontSize: 11)),
                Text('Part C', style: TextStyle(color: ShuffleColors.textDim, fontSize: 11)),
              ],
            ),
          ],
        ),
      );
    });
  }
}
