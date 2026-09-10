import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import '../models/routine_data.dart';
import 'audio_source_service.dart';
import 'beat_clock.dart';

enum TransportState { idle, leadIn, playing, paused }

/// 재생 상태의 유일한 소유자.
/// exactBeat는 언제나 songTime(경과 음악 시간)으로부터 다시 계산되어
/// 스케줄러 상태가 어긋날 여지가 없도록 한다 (원 설계 원칙 계승).
class PlayerController extends ChangeNotifier {
  final AudioSourceService audioSource;
  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _clickPlayer = AudioPlayer();

  PlayerController(this.audioSource) {
    _musicPlayer.setReleaseMode(ReleaseMode.stop);
    _clickPlayer.setReleaseMode(ReleaseMode.stop);
  }

  TransportState _state = TransportState.idle;
  TransportState get state => _state;

  // 현재 음악 경과 시간(초). 오디오 모드에선 오디오 포지션으로 주기 보정됨.
  double _songTimeSec = 0.0;
  double get songTimeSec => _songTimeSec;

  double get exactBeat => clampBeatDouble(beatFromSongTime(_songTimeSec));
  int get currentBeat => exactBeat.floor().clamp(1, kTotalBeats);

  double _speedPercent = 100; // 50~150
  double get speedPercent => _speedPercent;
  double get speedFactor => _speedPercent / 100.0;

  bool _mirrored = false;
  bool get mirrored => _mirrored;

  // 메트로놈: 기본 ON. 음원이 있어도 클릭음을 오버레이로 들려줄 수 있음.
  bool _metronomeOn = true;
  bool get metronomeOn => _metronomeOn;
  MetronomeAccentPattern _accentPattern = MetronomeAccentPattern.fourOnFirst;
  MetronomeAccentPattern get accentPattern => _accentPattern;

  void setMetronomeOn(bool v) {
    _metronomeOn = v;
    notifyListeners();
  }

  void setAccentPattern(MetronomeAccentPattern p) {
    _accentPattern = p;
    notifyListeners();
  }

  // 드릴 구간
  int? _drillStart;
  int? _drillEnd;
  bool _drillLoop = false;
  int? get drillStart => _drillStart;
  int? get drillEnd => _drillEnd;
  bool get drillLoop => _drillLoop;
  bool get hasDrill => _drillStart != null && _drillEnd != null;

  // 리드인
  int _leadInBeatsLeft = 0;
  int get leadInBeatsLeft => _leadInBeatsLeft;
  String get leadInLabel {
    // 8박: 준비×4 -> 4,3,2,1
    final idx = 8 - _leadInBeatsLeft; // 0..7 진행됨
    if (idx < 4) return '준비';
    final countdown = 8 - idx; // 4,3,2,1
    return '$countdown';
  }

  Timer? _ticker;
  DateTime? _lastTick;
  bool _usingAudio = false;

  void toggleMirror() {
    _mirrored = !_mirrored;
    notifyListeners();
  }

  void setSpeed(double percent) {
    _speedPercent = percent.clamp(50, 150);
    if (_usingAudio) {
      _musicPlayer.setPlaybackRate(speedFactor);
    }
    notifyListeners();
  }

  void setDrill(int? start, int? end) {
    _drillStart = start;
    _drillEnd = end;
    notifyListeners();
  }

  void setDrillLoop(bool v) {
    _drillLoop = v;
    notifyListeners();
  }

  void clearDrill() {
    _drillStart = null;
    _drillEnd = null;
    _drillLoop = false;
    notifyListeners();
  }

  Future<void> playPause() async {
    if (_state == TransportState.leadIn) {
      await stop();
      return;
    }
    if (_state == TransportState.playing) {
      await pause();
      return;
    }
    await _startWithLeadIn();
  }

  Future<void> _startWithLeadIn() async {
    _usingAudio = audioSource.hasAudio;
    final startBeat = hasDrill ? _drillStart! : (_songTimeSec <= 0.001 ? 1 : currentBeat);
    _songTimeSec = songTimeFromBeat(startBeat.toDouble());

    _state = TransportState.leadIn;
    _leadInBeatsLeft = 8;
    notifyListeners();

    _startTicker();
  }

  Future<void> pause() async {
    _state = TransportState.paused;
    _ticker?.cancel();
    if (_usingAudio) {
      await _musicPlayer.pause();
    }
    notifyListeners();
  }

  Future<void> stop() async {
    _state = TransportState.idle;
    _ticker?.cancel();
    _leadInBeatsLeft = 0;
    if (_usingAudio) {
      await _musicPlayer.stop();
    }
    notifyListeners();
  }

  Future<void> seekToBeat(double beat) async {
    _songTimeSec = songTimeFromBeat(clampBeatDouble(beat));
    if (_usingAudio && (_state == TransportState.playing)) {
      await _musicPlayer.seek(Duration(
          milliseconds: (_songTimeSec * 1000).round().clamp(0, 1 << 30)));
    }
    notifyListeners();
  }

  void _startTicker() {
    _lastTick = DateTime.now();
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 16), (_) => _onTick());
  }

  Future<void> _beginActualPlayback() async {
    if (_usingAudio) {
      final bytes = audioSource.audioBytes;
      if (bytes != null) {
        await _musicPlayer.setPlaybackRate(speedFactor);
        await _musicPlayer.play(BytesSource(bytes));
        final targetMs = ((_songTimeSec + audioSource.syncOffsetSec) * 1000)
            .round()
            .clamp(0, 1 << 30);
        await _musicPlayer.seek(Duration(milliseconds: targetMs));
      }
    }
  }

  void _onTick() {
    final now = DateTime.now();
    final dtSec = now.difference(_lastTick!).inMicroseconds / 1e6;
    _lastTick = now;

    if (_state == TransportState.leadIn) {
      final beatDur = kBeatDurationSec / speedFactor;
      _leadInProgressSec += dtSec;
      if (_leadInProgressSec >= beatDur) {
        _leadInProgressSec -= beatDur;
        _leadInBeatsLeft--;
        _playClick(strong: _leadInBeatsLeft <= 3);
        if (_leadInBeatsLeft <= 0) {
          _state = TransportState.playing;
          _beginActualPlayback();
        }
      }
      notifyListeners();
      return;
    }

    if (_state != TransportState.playing) return;

    final prevBeatFloor = currentBeat;

    if (_usingAudio) {
      // 오디오 진짜 위치로 주기 보정 (진실 공급원)
      _musicPlayer.getCurrentPosition().then((pos) {
        if (pos != null && _state == TransportState.playing) {
          _songTimeSec = (pos.inMilliseconds / 1000.0) - audioSource.syncOffsetSec;
        }
      });
      // 폴링 사이 프레임에서는 로컬 외삽으로 부드럽게
      _songTimeSec += dtSec * speedFactor;
    } else {
      _songTimeSec += dtSec * speedFactor;
    }

    // 드릴 루프 체크
    if (hasDrill && _drillLoop) {
      if (exactBeat > _drillEnd! + 0.999) {
        seekToBeat(_drillStart!.toDouble());
        if (_usingAudio) _beginActualPlayback();
        notifyListeners();
        return;
      }
    } else if (exactBeat >= kTotalBeats + 0.999) {
      stop();
      return;
    }

    final newBeatFloor = currentBeat;
    if (newBeatFloor != prevBeatFloor && _metronomeOn) {
      _playMetronomeBeat(newBeatFloor);
    }

    notifyListeners();
  }

  double _leadInProgressSec = 0.0;

  void _playClick({required bool strong}) {
    if (!_metronomeOn) return;
    _clickPlayer.play(AssetSource('audio/kung.mp3'), volume: strong ? 1.0 : 0.7);
  }

  void _playMetronomeBeat(int beat) {
    final accent = isMetronomeAccentBeat(_accentPattern, beat);
    final asset = accent ? 'audio/kung.mp3' : 'audio/jjak.mp3';
    _clickPlayer.play(AssetSource(asset), volume: accent ? 1.0 : 0.85);
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _musicPlayer.dispose();
    _clickPlayer.dispose();
    super.dispose();
  }
}
