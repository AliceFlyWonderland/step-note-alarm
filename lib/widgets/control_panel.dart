import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/routine_data.dart';
import '../services/player_controller.dart';
import '../theme.dart';

/// 하단 조작: 재생/정지, 속도, 드릴 구간, 거울모드
class ControlPanel extends StatelessWidget {
  const ControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerController>();
    final isPlaying = player.state == TransportState.playing;
    final isLeadIn = player.state == TransportState.leadIn;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: ShuffleColors.panel,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // 재생/정지
          _CircleButton(
            icon: isLeadIn
                ? Icons.close
                : (isPlaying ? Icons.pause : Icons.play_arrow),
            color: isLeadIn ? ShuffleColors.danger : ShuffleColors.accent,
            onTap: () => player.playPause(),
          ),
          if (isLeadIn)
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                player.leadInLabel,
                style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          const SizedBox(width: 20),
          // 속도
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('속도', style: TextStyle(color: ShuffleColors.textDim, fontSize: 11)),
              Row(
                children: [
                  IconButton(
                    iconSize: 18,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                    onPressed: () => player.setSpeed(player.speedPercent - 5),
                    icon: const Icon(Icons.remove, color: Colors.white),
                  ),
                  SizedBox(
                    width: 46,
                    child: Text(
                      '${player.speedPercent.toStringAsFixed(0)}%',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    iconSize: 18,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                    onPressed: () => player.setSpeed(player.speedPercent + 5),
                    icon: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 20),
          // 드릴 구간
          Expanded(
            child: Row(
              children: [
                const Text('드릴 구간', style: TextStyle(color: ShuffleColors.textDim, fontSize: 12)),
                const SizedBox(width: 8),
                Expanded(
                  child: player.hasDrill
                      ? Text(
                          '${player.drillStart}~${player.drillEnd}박',
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                        )
                      : const Text('전체 루틴', style: TextStyle(color: Colors.white38, fontSize: 13)),
                ),
                if (player.hasDrill)
                  Row(
                    children: [
                      const Text('반복', style: TextStyle(color: ShuffleColors.textDim, fontSize: 12)),
                      Switch(
                        value: player.drillLoop,
                        onChanged: (v) => player.setDrillLoop(v),
                        activeThumbColor: ShuffleColors.accent,
                      ),
                    ],
                  ),
                TextButton(
                  onPressed: () => _showDrillPicker(context, player),
                  child: Text(player.hasDrill ? '변경' : '설정'),
                ),
                if (player.hasDrill)
                  IconButton(
                    onPressed: () => player.clearDrill(),
                    icon: const Icon(Icons.close, color: ShuffleColors.textDim, size: 18),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // 거울 모드
          _ToggleChip(
            label: '거울',
            icon: Icons.flip,
            active: player.mirrored,
            onTap: () => player.toggleMirror(),
          ),
        ],
      ),
    );
  }

  void _showDrillPicker(BuildContext context, PlayerController player) {
    int start = player.drillStart ?? 1;
    int end = player.drillEnd ?? kTotalBeats;
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setState) {
          return AlertDialog(
            backgroundColor: ShuffleColors.panel,
            title: const Text('드릴 구간 설정', style: TextStyle(color: Colors.white)),
            content: SizedBox(
              width: 360,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('시작: $start박', style: const TextStyle(color: Colors.white)),
                  Slider(
                    value: start.toDouble(),
                    min: 1,
                    max: kTotalBeats.toDouble(),
                    divisions: kTotalBeats - 1,
                    onChanged: (v) => setState(() {
                      start = v.round();
                      if (start > end) end = start;
                    }),
                  ),
                  Text('종료: $end박', style: const TextStyle(color: Colors.white)),
                  Slider(
                    value: end.toDouble(),
                    min: 1,
                    max: kTotalBeats.toDouble(),
                    divisions: kTotalBeats - 1,
                    onChanged: (v) => setState(() {
                      end = v.round();
                      if (end < start) start = end;
                    }),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('취소'),
              ),
              ElevatedButton(
                onPressed: () {
                  player.setDrill(start, end);
                  player.seekToBeat(start.toDouble());
                  Navigator.of(ctx).pop();
                },
                child: const Text('적용'),
              ),
            ],
          );
        });
      },
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _CircleButton({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 10)],
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}

class _ToggleChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _ToggleChip({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: active ? ShuffleColors.accent : ShuffleColors.panelLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
