import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets.dart';
import '../data.dart';
import 'lesson.dart';
import 'quiz.dart';

class _LessonItem {
  final String title;
  final String meta;
  final bool done;
  final bool active;
  final bool test;
  const _LessonItem(this.title, this.meta, {this.done = false, this.active = false, this.test = false});
}

class SubjectDetailScreen extends StatelessWidget {
  final Subject subject;
  const SubjectDetailScreen({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    final lessons = [
      const _LessonItem('Introduction to Algebra', '12 min · Video', done: true),
      const _LessonItem('Linear Equations', '18 min · Video', done: true),
      const _LessonItem('Quadratic Equations', '15 min · Video', active: true),
      const _LessonItem('Factorisation', '14 min · Reading'),
      const _LessonItem('Polynomials', '20 min · Video'),
      const _LessonItem('Chapter Test', '10 questions', test: true),
    ];

    return Scaffold(
      body: Column(
        children: [
          // hero
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(22, 58, 22, 26),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [subject.c1, subject.c2],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Stack(
                children: [
                  Positioned(
                    right: -30, top: -10,
                    child: Container(width: 160, height: 160, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.10))),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Pressable(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(14)),
                          child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(subject.name, style: jk(26, weight: FontWeight.w800, color: Colors.white, spacing: -0.4)),
                                Text(subject.urdu, style: urdu(size: 18, color: Colors.white.withOpacity(0.9))),
                                const SizedBox(height: 6),
                                Text('Class 10 · ${subject.lessons} lessons', style: jk(13, weight: FontWeight.w600, color: Colors.white70)),
                              ],
                            ),
                          ),
                          ProgressRing(
                            size: 76, stroke: 8, value: subject.progress.toDouble(),
                            colors: [Colors.white, const Color(0xFFC9D2FF)],
                            track: Colors.white30,
                            center: Text('${subject.progress}%', style: jk(17, weight: FontWeight.w800, color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // chapter header
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Chapter 4 · Algebra', style: jk(17, weight: FontWeight.w700, spacing: -0.2)),
                Text('2/6', style: jk(12.5, weight: FontWeight.w700, color: AppColors.teal600)),
              ],
            ),
          ),

          // lesson list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
              itemCount: lessons.length,
              itemBuilder: (_, i) {
                final l = lessons[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AppCard(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                    border: l.active ? Border.all(color: AppColors.indigo400.withOpacity(0.5), width: 1.5) : null,
                    onTap: () {
                      if (l.test) {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const QuizScreen()));
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LessonScreen()));
                      }
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 38, height: 38,
                          decoration: BoxDecoration(
                            color: l.done
                                ? AppColors.successBg
                                : l.test
                                    ? const Color(0xFFFFF1F6)
                                    : l.active
                                        ? AppColors.indigo50
                                        : AppColors.surfaceSunken,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            l.done
                                ? Icons.check_rounded
                                : l.test
                                    ? Icons.edit_rounded
                                    : l.active
                                        ? Icons.play_arrow_rounded
                                        : Icons.menu_book_rounded,
                            size: 18,
                            color: l.done
                                ? AppColors.success
                                : l.test
                                    ? AppColors.rose
                                    : l.active
                                        ? AppColors.indigo500
                                        : AppColors.ink3,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l.title, style: jk(14.5, weight: FontWeight.w700)),
                              const SizedBox(height: 1),
                              Text(l.meta, style: jk(12.5, weight: FontWeight.w600, color: AppColors.ink3)),
                            ],
                          ),
                        ),
                        if (l.active)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(color: AppColors.indigo50, borderRadius: BorderRadius.circular(999)),
                            child: Text('Resume', style: jk(11, weight: FontWeight.w800, color: AppColors.indigo500)),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
