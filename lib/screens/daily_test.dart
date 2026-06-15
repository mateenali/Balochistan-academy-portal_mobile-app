import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets.dart';
import 'quiz.dart';

/// Daily test — today's short assessment plus the last few days' results.
class DailyTestScreen extends StatelessWidget {
  const DailyTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const recent = [
      ['Sat 13 Jun', 'Mathematics', 8, 10],
      ['Fri 12 Jun', 'Chemistry', 7, 10],
      ['Thu 11 Jun', 'Physics', 9, 10],
      ['Wed 10 Jun', 'English', 6, 10],
    ];
    return AppScreen(
      title: 'Daily Test',
      bottom: PrimaryButton(
        label: "Start today's test",
        icon: Icons.play_arrow_rounded,
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const QuizScreen())),
        colors: const [AppColors.apricot, AppColors.apricot2],
      ),
      children: [
        AppCard(
          gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.apricot, AppColors.apricot2]),
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("TODAY · 15 JUN", style: jk(11.5, weight: FontWeight.w700, color: Colors.white70, spacing: 0.8)),
                const SizedBox(height: 7),
                Text('Daily Challenge', style: jk(20, weight: FontWeight.w800, color: Colors.white)),
                const SizedBox(height: 2),
                Text('10 questions · 10 minutes', style: jk(13, weight: FontWeight.w600, color: Colors.white70)),
              ]),
            ),
            const Orb(size: 60, color: Colors.white, shadow: Color(0x55142E3C), child: Icon(Icons.today_rounded, color: AppColors.apricot2, size: 30)),
          ]),
        ),
        const SizedBox(height: 18),
        AppCard(
          gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.white, Color(0xFFFFF7EE)]),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(children: [
            FloatY(distance: 8, child: const Orb(size: 48, color: AppColors.apricot, shadow: Color(0x80FF7828), child: Icon(Icons.local_fire_department, color: Colors.white, size: 24))),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('4-day daily streak 🔥', style: jk(15.5, weight: FontWeight.w800)),
              Text('Take today\'s test to keep it going', style: jk(12.5, weight: FontWeight.w600, color: AppColors.ink3)),
            ])),
          ]),
        ),
        const SizedBox(height: 22),
        Text('Recent days', style: jk(15, weight: FontWeight.w800)),
        const SizedBox(height: 12),
        ...recent.map((r) {
          final got = r[2] as int, total = r[3] as int;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
              child: Row(children: [
                const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 22),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(r[1] as String, style: jk(14, weight: FontWeight.w800)),
                  Text(r[0] as String, style: jk(12.5, weight: FontWeight.w600, color: AppColors.ink3)),
                ])),
                Text('$got/$total', style: jk(16, weight: FontWeight.w800, color: AppColors.teal600)),
              ]),
            ),
          );
        }),
      ],
    );
  }
}
