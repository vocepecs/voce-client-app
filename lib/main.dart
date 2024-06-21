import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/auth_cubit.dart';
import 'package:voce/screens/auth_screens/root_screen.dart';
import 'package:voce/services/auth_repository.dart';
import 'package:voce/services/voce_api_repository.dart';

GetIt locator = GetIt.I;
late List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.landscapeLeft,
  //     DeviceOrientation.landscapeRight,
  //   ]);

  cameras = await availableCameras();
  final audioContext = AudioContext(
    iOS: AudioContextIOS(
      category: AVAudioSessionCategory.ambient,
      options: [
        AVAudioSessionOptions.defaultToSpeaker,
        AVAudioSessionOptions.mixWithOthers,
      ],
    ),
  );
  AudioPlayer.global.setAudioContext(audioContext);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(
        voceAPIRepository: VoceAPIRepository(),
        authRepository: AuthRepository(),
      ),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: false,
          primaryColor: Color(0xff7fc8f8),
          textTheme: TextTheme(
            displayLarge: GoogleFonts.poppins(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
        home: RootScreen(),
      ),
    );
  }
}
