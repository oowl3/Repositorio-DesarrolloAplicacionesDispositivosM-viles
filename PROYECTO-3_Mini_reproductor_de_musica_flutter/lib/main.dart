import 'package:flutter/material.dart';
import 'music_player_screen.dart';

void main() {
  runApp(const CoreApp());
}

class CoreApp extends StatelessWidget {
  const CoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reproductor Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212), // Un fondo oscuro minimalista
      ),
      home: const MusicPlayerScreen(),
    );
  }
}