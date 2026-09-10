import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/audio_source_service.dart';
import '../services/player_controller.dart';
import '../theme.dart';

/// 우상단 음원·싱크 상태 칩. 눌러서 다이얼로그로 음원 등록/보정.
class SyncStatusChip extends StatelessWidget {
  const SyncStatusChip({super.key});

  @override
  Widget build(BuildContext context) {
    final audio = context.watch<AudioSourceService>();

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => _showSyncDialog(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: ShuffleColors.panelLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: audio.hasAudio ? ShuffleColors.ok : ShuffleColors.textDim,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              audio.hasAudio ? Icons.graphic_eq : Icons.music_off,
              size: 16,
              color: audio.hasAudio ? ShuffleColors.ok : ShuffleColors.textDim,
            ),
            const SizedBox(width: 6),
            Text(
              audio.hasAudio ? '음원 연결됨' : '메트로놈 모드',
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  void _showSyncDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const SyncDialog(),
    );
  }
}

class SyncDialog extends StatefulWidget {
  const SyncDialog({super.key});

  @override
  State<SyncDialog> createState() => _SyncDialogState();
}

class _SyncDialogState extends State<SyncDialog> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final audio = context.watch<AudioSourceService>();
    final player = context.watch<PlayerController>();

    return Dialog(
      backgroundColor: ShuffleColors.panel,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('음원 · 싱크 설정',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 18),
              const Text('1. 음원', style: TextStyle(color: ShuffleColors.accent, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                audio.hasAudio ? '선택된 파일: ${audio.fileName}' : '음원 파일이 등록되지 않았습니다 (메트로놈 모드)',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _loading
                        ? null
                        : () async {
                            setState(() => _loading = true);
                            await audio.pickAudioFile();
                            setState(() => _loading = false);
                          },
                    icon: const Icon(Icons.upload_file, size: 18),
                    label: Text(_loading ? '불러오는 중...' : '음원 파일 선택'),
                  ),
                  if (audio.hasAudio) ...[
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () => audio.clearAudio(),
                      child: const Text('제거', style: TextStyle(color: ShuffleColors.danger)),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 22),
              const Text('2. 싱크 보정', style: TextStyle(color: ShuffleColors.accent, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                '재생해서 곡을 흘리다가 안무 1박이 오는 순간을 맞춰 -0.1s/+0.1s로 조정하세요.',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => audio.adjustSyncOffset(-0.1),
                    icon: const Icon(Icons.remove_circle_outline, color: Colors.white),
                  ),
                  Text(
                    '${audio.syncOffsetSec.toStringAsFixed(2)} s',
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => audio.adjustSyncOffset(0.1),
                    icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Center(
                child: OutlinedButton(
                  onPressed: () {
                    // "지금이 1박" - 현재 재생 위치를 1박으로 재정렬
                    audio.setSyncOffset(0.0);
                    player.seekToBeat(1);
                  },
                  child: const Text('지금이 1박'),
                ),
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
