import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets.dart';
import 'onboarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2400), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (_, a, __) => FadeTransition(opacity: a, child: const OnboardingScreen()),
      ));
    });
  }

  Widget _badge(IconData icon, Alignment a, Duration d) {
    return Align(
      alignment: a,
      child: FloatY(
        distance: 10,
        duration: const Duration(seconds: 4),
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.25)),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.indigo500, AppColors.teal500],
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 160),
              child: Stack(children: [
                _badge(Icons.functions, const Alignment(-1, -1), const Duration(seconds: 4)),
                _badge(Icons.bubble_chart, const Alignment(1, -0.9), const Duration(seconds: 5)),
                _badge(Icons.science, const Alignment(-0.9, 1), const Duration(seconds: 6)),
                _badge(Icons.menu_book, const Alignment(1, 0.95), const Duration(seconds: 5)),
              ]),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatY(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Orb(
                          size: 132,
                          color: Colors.white,
                          shadow: const Color(0x73142E3C),
                          child: const Icon(Icons.psychology, size: 62, color: AppColors.indigo500),
                        ),
                        const Positioned(
                          top: -8, right: -10,
                          child: Icon(Icons.auto_awesome, color: AppColors.gold, size: 28),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  Text('Balochistan Academy Portal', textAlign: TextAlign.center, style: jk(30, weight: FontWeight.w800, color: Colors.white, spacing: -1)),
                  const SizedBox(height: 4),
                  Text('Your AI study companion', style: jk(15, weight: FontWeight.w600, color: Colors.white.withOpacity(0.92))),
                  const SizedBox(height: 22),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(999)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.track_changes, color: Colors.white, size: 15),
                      const SizedBox(width: 7),
                      Text('Made for Balochistan students', style: jk(12.5, weight: FontWeight.w700, color: Colors.white)),
                    ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
