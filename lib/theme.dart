import 'package:flutter/material.dart';

/// 강/약박은 크기·밝기로만 구분. 색은 왼발(청록)/오른발(주황) 전용.
class ShuffleColors {
  static const Color bg = Color(0xFF0A0E17);
  static const Color panel = Color(0xFF121826);
  static const Color panelLight = Color(0xFF1A2233);
  static const Color leftFoot = Color(0xFF23D5D5); // 청록
  static const Color rightFoot = Color(0xFFFF8A3D); // 주황
  static const Color judgment = Color(0xFFFFFFFF);
  static const Color wipeHighlight = Color(0xFFFFE066);
  static const Color accent = Color(0xFF6C7CFF);
  static const Color danger = Color(0xFFFF4D6D);
  static const Color ok = Color(0xFF3DDC84);
  static const Color textDim = Color(0xFF8A93A6);
}

ThemeData buildShuffleTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: ShuffleColors.bg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: ShuffleColors.accent,
      brightness: Brightness.dark,
      surface: ShuffleColors.panel,
    ),
    fontFamily: 'Roboto',
    cardTheme: const CardThemeData(
      color: ShuffleColors.panel,
      elevation: 0,
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: ShuffleColors.panel,
    ),
    sliderTheme: const SliderThemeData(
      activeTrackColor: ShuffleColors.accent,
      thumbColor: ShuffleColors.accent,
    ),
  );
}
