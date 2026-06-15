import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/splash.dart';

void main() => runApp(const EStudyApp());

class EStudyApp extends StatelessWidget {
  const EStudyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Balochistan Academy Portal',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const SplashScreen(),
    );
  }
}
