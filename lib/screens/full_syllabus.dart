import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets.dart';
import '../data.dart';
import 'lesson.dart';

/// Full syllabus — every subject with its chapter count and progress.
class FullSyllabusScreen extends StatelessWidget {
  const FullSyllabusScreen({super.key});

  void _open(BuildContext c) => Navigator.of(c).push(MaterialPageRoute(builder: (_) => const LessonScreen()));

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: 'Full Syllabus',
      children: [
        AppCard(
          gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.indigo400, AppColors.indigo600]),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(children: [
            const Orb(size: 46, color: Colors.white, shadow: Color(0x55142E3C), child: Icon(Icons.menu_book_rounded, color: AppColors.indigo500, size: 24)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Class 10 · Science Group', style: jk(15, weight: FontWeight.w800, color: Colors.white)),
                const SizedBox(height: 2),
                Text('${kSubjects.length} subjects · ${kSubjects.fold<int>(0, (a, s) => a + s.lessons)} chapters', style: jk(12.5, weight: FontWeight.w600, color: Colors.white70)),
              ]),
            ),
          ]),
        ),
        const SizedBox(height: 18),
        ...kSubjects.map((s) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AppCard(
                onTap: () => _open(context),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                child: Row(children: [
                  GradientTile(icon: s.icon, c1: s.c1, c2: s.c2, size: 46, radius: 14, iconSize: 22),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(s.name, style: jk(14.5, weight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      ProgressBar(value: s.progress.toDouble(), colors: [s.c1, s.c2]),
                      const SizedBox(height: 6),
                      Text('${s.lessons} chapters · ${s.progress}% complete', style: jk(12, weight: FontWeight.w600, color: AppColors.ink3)),
                    ]),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.ink3),
                ]),
              ),
            )),
      ],
    );
  }
}
