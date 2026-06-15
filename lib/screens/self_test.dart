import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets.dart';
import '../data.dart';
import 'quiz.dart';

/// Self test — student picks a subject + length, then starts a practice quiz.
class SelfTestScreen extends StatefulWidget {
  const SelfTestScreen({super.key});
  @override
  State<SelfTestScreen> createState() => _SelfTestScreenState();
}

class _SelfTestScreenState extends State<SelfTestScreen> {
  int _subject = 0;
  int _count = 10;

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: 'Self Test',
      bottom: PrimaryButton(
        label: 'Start test',
        icon: Icons.play_arrow_rounded,
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const QuizScreen())),
      ),
      children: [
        AppCard(
          gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.teal400, AppColors.teal600]),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(children: [
            const Orb(size: 46, color: Colors.white, shadow: Color(0x55142E3C), child: Icon(Icons.psychology_rounded, color: AppColors.teal600, size: 24)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Practice on your own', style: jk(15, weight: FontWeight.w800, color: Colors.white)),
                const SizedBox(height: 2),
                Text('No grade is recorded — just for learning', style: jk(12.5, weight: FontWeight.w600, color: Colors.white70)),
              ]),
            ),
          ]),
        ),
        const SizedBox(height: 22),
        Text('Choose a subject', style: jk(15, weight: FontWeight.w800)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(kSubjects.length, (i) {
            final s = kSubjects[i];
            final sel = _subject == i;
            return Pressable(
              onTap: () => setState(() => _subject = i),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: sel ? null : AppColors.surface,
                  gradient: sel ? LinearGradient(colors: [s.c1, s.c2]) : null,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: sel ? Colors.transparent : AppColors.line),
                  boxShadow: sel ? null : cardShadow,
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(s.icon, size: 17, color: sel ? Colors.white : s.c2),
                  const SizedBox(width: 7),
                  Text(s.name, style: jk(13, weight: FontWeight.w700, color: sel ? Colors.white : AppColors.ink)),
                ]),
              ),
            );
          }),
        ),
        const SizedBox(height: 22),
        Text('Number of questions', style: jk(15, weight: FontWeight.w800)),
        const SizedBox(height: 12),
        Row(
          children: [5, 10, 20, 30].map((n) {
            final sel = _count == n;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Pressable(
                  onTap: () => setState(() => _count = n),
                  child: Container(
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: sel ? AppColors.indigo50 : AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: sel ? AppColors.indigo400 : AppColors.line, width: sel ? 1.6 : 1),
                    ),
                    child: Text('$n', style: jk(16, weight: FontWeight.w800, color: sel ? AppColors.indigo600 : AppColors.ink2)),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
