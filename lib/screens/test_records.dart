import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets.dart';

class _Record {
  final String title;
  final String subject;
  final String date;
  final int score; // 0..100
  final String type;
  const _Record(this.title, this.subject, this.date, this.score, this.type);
}

const _records = [
  _Record('Quadratic Equations', 'Mathematics', '14 Jun 2026', 88, 'Self'),
  _Record('Acids & Bases', 'Chemistry', '12 Jun 2026', 72, 'Daily'),
  _Record('Newton\'s Laws', 'Physics', '10 Jun 2026', 64, 'Teacher'),
  _Record('Cell Structure', 'Biology', '08 Jun 2026', 91, 'Self'),
  _Record('Tenses', 'English', '05 Jun 2026', 55, 'Monthly'),
  _Record('Algorithms', 'Computer Sci', '02 Jun 2026', 78, 'Daily'),
];

/// Test records — history of every test the student has taken.
class TestRecordsScreen extends StatelessWidget {
  const TestRecordsScreen({super.key});

  Color _c(int s) => s >= 80
      ? AppColors.success
      : s >= 60
          ? AppColors.apricot2
          : AppColors.rose2;

  @override
  Widget build(BuildContext context) {
    final avg = (_records.fold<int>(0, (a, r) => a + r.score) / _records.length).round();
    return AppScreen(
      title: 'Test Records',
      children: [
        Row(children: [
          Expanded(child: _stat('${_records.length}', 'Tests taken', AppColors.indigo400, AppColors.indigo600)),
          const SizedBox(width: 12),
          Expanded(child: _stat('$avg%', 'Average score', AppColors.teal400, AppColors.teal600)),
        ]),
        const SizedBox(height: 18),
        Text('History', style: jk(15, weight: FontWeight.w800)),
        const SizedBox(height: 12),
        ..._records.map((r) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AppCard(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                child: Row(children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(r.title, style: jk(14.5, weight: FontWeight.w800)),
                      const SizedBox(height: 3),
                      Text('${r.subject} · ${r.date}', style: jk(12.5, weight: FontWeight.w600, color: AppColors.ink3)),
                      const SizedBox(height: 8),
                      Chip2(r.type, bg: AppColors.surfaceSunken, fg: AppColors.ink2),
                    ]),
                  ),
                  const SizedBox(width: 12),
                  Column(children: [
                    Text('${r.score}%', style: jk(20, weight: FontWeight.w800, color: _c(r.score))),
                    Text('score', style: jk(11, weight: FontWeight.w600, color: AppColors.ink3)),
                  ]),
                ]),
              ),
            )),
      ],
    );
  }

  Widget _stat(String value, String label, Color c1, Color c2) {
    return AppCard(
      gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [c1, c2]),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value, style: jk(26, weight: FontWeight.w800, color: Colors.white)),
        const SizedBox(height: 2),
        Text(label, style: jk(12.5, weight: FontWeight.w600, color: Colors.white70)),
      ]),
    );
  }
}
