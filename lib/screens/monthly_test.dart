import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets.dart';
import 'quiz.dart';

/// Monthly test — the comprehensive monthly assessment and past months.
class MonthlyTestScreen extends StatelessWidget {
  const MonthlyTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const past = [
      ['May 2026', 81],
      ['April 2026', 74],
      ['March 2026', 68],
    ];
    return AppScreen(
      title: 'Monthly Test',
      bottom: PrimaryButton(
        label: 'Start monthly test',
        icon: Icons.play_arrow_rounded,
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const QuizScreen())),
        colors: const [AppColors.rose, AppColors.rose2],
      ),
      children: [
        AppCard(
          gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.rose, AppColors.rose2]),
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('JUNE 2026', style: jk(11.5, weight: FontWeight.w700, color: Colors.white70, spacing: 0.8)),
                const SizedBox(height: 7),
                Text('Monthly Assessment', style: jk(20, weight: FontWeight.w800, color: Colors.white)),
                const SizedBox(height: 2),
                Text('All subjects · 50 questions · 90 min', style: jk(13, weight: FontWeight.w600, color: Colors.white70)),
                const SizedBox(height: 10),
                Chip2('Opens 28 Jun', bg: Colors.white24, fg: Colors.white, icon: Icons.event_rounded),
              ]),
            ),
            const SizedBox(width: 10),
            const Orb(size: 60, color: Colors.white, shadow: Color(0x55142E3C), child: Icon(Icons.calendar_month_rounded, color: AppColors.rose2, size: 30)),
          ]),
        ),
        const SizedBox(height: 18),
        AppCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Syllabus covered', style: jk(14.5, weight: FontWeight.w800)),
            const SizedBox(height: 10),
            const ProgressBar(value: 70, colors: [AppColors.rose, AppColors.rose2]),
            const SizedBox(height: 8),
            Text('Chapters 1–6 of every subject', style: jk(12.5, weight: FontWeight.w600, color: AppColors.ink3)),
          ]),
        ),
        const SizedBox(height: 22),
        Text('Previous months', style: jk(15, weight: FontWeight.w800)),
        const SizedBox(height: 12),
        ...past.map((m) {
          final score = m[1] as int;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
              child: Row(children: [
                const Icon(Icons.calendar_month_rounded, color: AppColors.ink3, size: 22),
                const SizedBox(width: 12),
                Expanded(child: Text(m[0] as String, style: jk(14.5, weight: FontWeight.w800))),
                Text('$score%', style: jk(18, weight: FontWeight.w800, color: score >= 75 ? AppColors.success : AppColors.apricot2)),
              ]),
            ),
          );
        }),
      ],
    );
  }
}
