import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'services/audio_source_service.dart';
import 'services/player_controller.dart';
import 'screens/home_screen.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 태블릿 가로 모드 전용
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  final audioSource = AudioSourceService();
  await audioSource.loadPersistedOffset();

  runApp(ShuffleBeatApp(audioSource: audioSource));
}

class ShuffleBeatApp extends StatelessWidget {
  final AudioSourceService audioSource;

  const ShuffleBeatApp({super.key, required this.audioSource});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AudioSourceService>.value(value: audioSource),
        ChangeNotifierProvider<PlayerController>(
          create: (_) => PlayerController(audioSource),
        ),
      ],
      child: MaterialApp(
        title: 'Shuffle Beat',
        debugShowCheckedModeBanner: false,
        theme: buildShuffleTheme(),
        home: const HomeScreen(),
      ),
    );
  }
}
