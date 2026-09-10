import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/beat_clock.dart';
import '../services/player_controller.dart';
import '../theme.dart';

/// 상단 메트로놈 상태 칩. 눌러서 ON/OFF 및 박자 패턴(꿍짝짝짝/꿍짝꿍짝) 선택.
class MetronomeChip extends StatelessWidget {
  const MetronomeChip({super.key});

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerController>();
    final on = player.metronomeOn;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => _showMetronomeDialog(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: ShuffleColors.panelLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: on ? ShuffleColors.accent : ShuffleColors.textDim,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              on ? Icons.speed : Icons.speed_outlined,
              size: 16,
              color: on ? ShuffleColors.accent : ShuffleColors.textDim,
            ),
            const SizedBox(width: 6),
            Text(
              on ? metronomePatternLabel(player.accentPattern) : '메트로놈 꺼짐',
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  void _showMetronomeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const MetronomeDialog(),
    );
  }
}

class MetronomeDialog extends StatelessWidget {
  const MetronomeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerController>();

    return Dialog(
      backgroundColor: ShuffleColors.panel,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          width: 380,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('메트로놈 설정',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('메트로놈 사용', style: TextStyle(color: Colors.white, fontSize: 15)),
                  Switch(
                    value: player.metronomeOn,
                    onChanged: (v) => player.setMetronomeOn(v),
                    activeThumbColor: ShuffleColors.accent,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text('박자 패턴', style: TextStyle(color: ShuffleColors.accent, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _PatternOption(
                label: '꿍짝짝짝',
                sublabel: '1박만 강박 (4박자 느낌)',
                selected: player.accentPattern == MetronomeAccentPattern.fourOnFirst,
                enabled: player.metronomeOn,
                onTap: () => player.setAccentPattern(MetronomeAccentPattern.fourOnFirst),
              ),
              const SizedBox(height: 10),
              _PatternOption(
                label: '꿍짝꿍짝',
                sublabel: '1, 3박 강박 (2박자 느낌)',
                selected: player.accentPattern == MetronomeAccentPattern.twoBeat,
                enabled: player.metronomeOn,
                onTap: () => player.setAccentPattern(MetronomeAccentPattern.twoBeat),
              ),
              const SizedBox(height: 18),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('닫기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PatternOption extends StatelessWidget {
  final String label;
  final String sublabel;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  const _PatternOption({
    required this.label,
    required this.sublabel,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.4,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: enabled ? onTap : null,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: selected ? ShuffleColors.accent.withValues(alpha: 0.22) : ShuffleColors.panelLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? ShuffleColors.accent : Colors.white24,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: selected ? ShuffleColors.accent : Colors.white38,
                size: 20,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1)),
                  Text(sublabel, style: const TextStyle(color: ShuffleColors.textDim, fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
