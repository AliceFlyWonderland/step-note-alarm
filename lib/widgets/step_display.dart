import 'package:flutter/material.dart';
import '../models/routine_data.dart';
import '../theme.dart';

/// 중앙: 현재 스텝 이름(대형) + 박자 도트 + 실행 설명
class CurrentStepDisplay extends StatelessWidget {
  final int beat;
  final bool mirrored;

  const CurrentStepDisplay({super.key, required this.beat, required this.mirrored});

  @override
  Widget build(BuildContext context) {
    final step = stepAtBeat(beat);
    final cue = cueAtBeat(beat);
    if (step == null) {
      return const Center(child: Text('—', style: TextStyle(color: Colors.white38, fontSize: 40)));
    }

    final localBeatIdx = beat - step.startBeat; // 0-indexed
    final totalInStep = step.beatCount;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            step.fullName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 84,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
        ),
        const SizedBox(height: 10),
        // 박자 도트
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(totalInStep, (i) {
            final active = i == localBeatIdx;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: active ? 16 : 11,
              height: active ? 16 : 11,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: active ? ShuffleColors.accent : Colors.white24,
                boxShadow: active
                    ? [BoxShadow(color: ShuffleColors.accent.withValues(alpha: 0.7), blurRadius: 10)]
                    : null,
              ),
            );
          }),
        ),
        const SizedBox(height: 14),
        if (cue != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              cue.footCue,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: ShuffleColors.textDim,
                fontSize: 17,
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
            ),
          ),
      ],
    );
  }
}

/// 중앙 하단: 다음 스텝. 스텝 첫 박에 강조됨.
class NextStepPreview extends StatelessWidget {
  final int beat;

  const NextStepPreview({super.key, required this.beat});

  @override
  Widget build(BuildContext context) {
    final step = stepAtBeat(beat);
    if (step == null) return const SizedBox(height: 40);
    final next = nextStepAfter(step);
    if (next == null) {
      return const SizedBox(
        height: 40,
        child: Center(
          child: Text('🏁 엔딩', style: TextStyle(color: Colors.white54, fontSize: 16)),
        ),
      );
    }

    final isFirstBeatOfCurrent = beat == step.startBeat;
    final beatsUntilNext = next.startBeat - beat;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: isFirstBeatOfCurrent
            ? ShuffleColors.accent.withValues(alpha: 0.25)
            : Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isFirstBeatOfCurrent ? ShuffleColors.accent : Colors.white24,
          width: isFirstBeatOfCurrent ? 2 : 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'NEXT',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(width: 12),
          // 테트리스식 "다음 블록" 미리보기 - 멀리서도 보이도록 크게, 5자 초과시 약어
          Text(
            next.bigLabel,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '$beatsUntilNext박 후',
            style: const TextStyle(color: ShuffleColors.textDim, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
