import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets.dart';
import '../Api/api_client.dart';
import 'login.dart';

class _Slide {
  final IconData icon;
  final Color c1, c2, sh;
  final String title, urduText, body;
  const _Slide(this.icon, this.c1, this.c2, this.sh, this.title, this.urduText, this.body);
}

const _slides = [
  _Slide(Icons.chat_bubble_rounded, AppColors.indigo400, AppColors.indigo600, Color(0x80454DD4),
      'Ask anything, anytime', 'کسی بھی وقت سوال پوچھیں',
      'Your personal AI tutor explains any concept in simple English or Urdu — step by step, at your pace.'),
  _Slide(Icons.camera_alt_rounded, AppColors.teal400, AppColors.teal600, Color(0x800D8979),
      'Snap & solve', 'تصویر کھینچیں، حل پائیں',
      'Stuck on a problem? Take a photo and get a clear, worked-out solution with every step shown.'),
  _Slide(Icons.track_changes, AppColors.apricot, AppColors.apricot2, Color(0x80F0742E),
      'A plan made for you', 'آپ کے لیے بنایا گیا منصوبہ',
      'Tell us your goals and exams — eStudy builds a daily study plan and keeps you on streak.'),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int i = 0;

  void _finish() {
    TokenManager.setOnboardingSeen();
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, a, __) => FadeTransition(opacity: a, child: const LoginScreen()),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final s = _slides[i];
    final last = i == _slides.length - 1;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 12, 22, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('eStudy', style: jk(18, weight: FontWeight.w800, spacing: -0.3)),
                  Pressable(onTap: _finish, child: Text('Skip', style: jk(13, weight: FontWeight.w700, color: AppColors.ink3))),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        FloatY(
                          child: Orb(size: 150, color: s.c1, shadow: s.sh, child: Icon(s.icon, size: 64, color: Colors.white)),
                        ),
                        const Positioned(top: 6, right: -6, child: Icon(Icons.auto_awesome, color: AppColors.gold, size: 24)),
                      ],
                    ),
                    const SizedBox(height: 46),
                    Text(s.title, textAlign: TextAlign.center, style: jk(27, weight: FontWeight.w800, spacing: -0.5)),
                    const SizedBox(height: 14),
                    Text(s.body, textAlign: TextAlign.center, style: jk(14.5, weight: FontWeight.w500, color: AppColors.ink2, height: 1.55)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 38),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_slides.length, (k) {
                      final active = k == i;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 3.5),
                        height: 7,
                        width: active ? 26 : 7,
                        decoration: BoxDecoration(
                          color: active ? s.c2 : AppColors.line,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 22),
                  PrimaryButton(
                    label: last ? 'Get started' : 'Continue',
                    icon: Icons.arrow_forward_rounded,
                    colors: i == 0 ? const [AppColors.indigo400, AppColors.indigo600] : const [AppColors.teal500, AppColors.teal600],
                    onTap: () {
                      if (last) {
                        _finish();
                      } else {
                        setState(() => i++);
                      }
                    },
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
