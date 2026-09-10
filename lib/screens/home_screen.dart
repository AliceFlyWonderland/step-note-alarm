import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/routine_data.dart';
import '../services/player_controller.dart';
import '../theme.dart';
import '../widgets/lyric_wipe_line.dart';
import '../widgets/step_display.dart';
import '../widgets/beat_runway.dart';
import '../widgets/progress_bar.dart';
import '../widgets/control_panel.dart';
import '../widgets/sync_panel.dart';
import '../widgets/metronome_panel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerController>();
    final beat = player.currentBeat;
    final part = stepAtBeat(beat)?.part ?? 'A';

    return Scaffold(
      backgroundColor: ShuffleColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Column(
            children: [
              // ── 상단: 파트/박자 배지 + 메트로놈 + 싱크칩
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _PartBadge(part: part, beat: beat),
                  const SizedBox(width: 10),
                  const MetronomeChip(),
                  const Spacer(),
                  const SyncStatusChip(),
                ],
              ),
              const SizedBox(height: 8),
              // ── 가사 라인 (전체 너비, 잘리지 않도록 FittedBox 적용)
              LyricWipeLine(exactBeat: player.exactBeat),
              const SizedBox(height: 4),
              // ── 중앙: 스텝 표시 + 발 방향 인디케이터
              Expanded(
                child: Row(
                  children: [
                    _FootIndicator(beat: beat, mirrored: player.mirrored),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: CurrentStepDisplay(beat: beat, mirrored: player.mirrored),
                          ),
                          NextStepPreview(beat: beat),
                          const SizedBox(height: 6),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // ── 비트 러너웨이
              SizedBox(
                height: 68,
                child: BeatRunway(exactBeat: player.exactBeat),
              ),
              const SizedBox(height: 8),
              // ── 진행 바
              RoutineProgressBar(
                exactBeat: player.exactBeat,
                drillStart: player.drillStart,
                drillEnd: player.drillEnd,
                onSeek: (b) => player.seekToBeat(b.toDouble()),
              ),
              const SizedBox(height: 8),
              // ── 조작 패널
              const ControlPanel(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PartBadge extends StatelessWidget {
  final String part;
  final int beat;

  const _PartBadge({required this.part, required this.beat});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: ShuffleColors.panelLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('PART $part', style: const TextStyle(color: ShuffleColors.accent, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Text('$beat/$kTotalBeats', style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

/// 발 지시는 데이터가 있는 구간에만 표시. 왼발=청록, 오른발=주황.
class _FootIndicator extends StatelessWidget {
  final int beat;
  final bool mirrored;

  const _FootIndicator({required this.beat, required this.mirrored});

  @override
  Widget build(BuildContext context) {
    final cue = cueAtBeat(beat);
    final text = cue?.footCue ?? '';
    bool showLeft = text.contains('왼발');
    bool showRight = text.contains('오른발');
    if (mirrored) {
      final tmp = showLeft;
      showLeft = showRight;
      showRight = tmp;
    }

    return SizedBox(
      width: 52,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _FootDot(active: showLeft, color: ShuffleColors.leftFoot, label: mirrored ? 'R' : 'L'),
          const SizedBox(height: 12),
          _FootDot(active: showRight, color: ShuffleColors.rightFoot, label: mirrored ? 'L' : 'R'),
        ],
      ),
    );
  }
}

class _FootDot extends StatelessWidget {
  final bool active;
  final Color color;
  final String label;

  const _FootDot({required this.active, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: active ? 38 : 26,
      height: active ? 38 : 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? color : color.withValues(alpha: 0.15),
        boxShadow: active ? [BoxShadow(color: color.withValues(alpha: 0.7), blurRadius: 14)] : null,
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: active ? Colors.black.withValues(alpha: 0.7) : color.withValues(alpha: 0.6),
          fontWeight: FontWeight.bold,
          fontSize: active ? 14 : 10,
        ),
      ),
    );
  }
}
