import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 음원 파일 로드 및 싱크 오프셋 보관.
/// 저작권 이슈로 저장소에 음원을 포함하지 않으므로 사용자가 기기에서 직접 선택.
/// (빠른 프로토타이핑 단계이므로 세션 내 메모리 보관 + 오프셋만 영구 저장)
class AudioSourceService extends ChangeNotifier {
  Uint8List? _audioBytes;
  String? _fileName;
  double _syncOffsetSec = 0.0;

  static const _prefKeyOffset = 'shuffle_beat_sync_offset_sec';

  Uint8List? get audioBytes => _audioBytes;
  String? get fileName => _fileName;
  bool get hasAudio => _audioBytes != null;
  double get syncOffsetSec => _syncOffsetSec;

  Future<void> loadPersistedOffset() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _syncOffsetSec = prefs.getDouble(_prefKeyOffset) ?? 0.0;
      notifyListeners();
    } catch (_) {
      // ignore
    }
  }

  Future<bool> pickAudioFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        withData: true,
      );
      if (result == null || result.files.isEmpty) return false;
      final f = result.files.first;
      if (f.bytes == null) return false;
      _audioBytes = f.bytes;
      _fileName = f.name;
      notifyListeners();
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('음원 로드 실패: $e');
      }
      return false;
    }
  }

  void clearAudio() {
    _audioBytes = null;
    _fileName = null;
    notifyListeners();
  }

  Future<void> setSyncOffset(double v) async {
    _syncOffsetSec = v;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_prefKeyOffset, v);
    } catch (_) {
      // ignore
    }
  }

  Future<void> adjustSyncOffset(double delta) async {
    await setSyncOffset(_syncOffsetSec + delta);
  }
}
