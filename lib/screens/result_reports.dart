import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets.dart';
import '../data.dart';

/// Result reports — overall performance and subject-wise breakdown.
class ResultReportsScreen extends StatelessWidget {
  const ResultReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final overall = (kSubjects.fold<int>(0, (a, s) => a + s.progress) / kSubjects.length).round();
    return AppScreen(
      title: 'Result Reports',
      bottom: GhostButton(label: 'Download PDF report', icon: Icons.download_rounded, onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Report exported', style: jk(13.5, weight: FontWeight.w700, color: Colors.white)),
          ),
        );
      }),
      children: [
        AppCard(
          gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF3A42C9), AppColors.indigo500]),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('OVERALL PERFORMANCE', style: jk(11.5, weight: FontWeight.w700, color: Colors.white70, spacing: 0.8)),
                const SizedBox(height: 8),
                Text('Good progress', style: jk(20, weight: FontWeight.w800, color: Colors.white)),
                const SizedBox(height: 2),
                Text('Across ${kSubjects.length} subjects this term', style: jk(13, weight: FontWeight.w600, color: Colors.white70)),
              ]),
            ),
            ProgressRing(
              size: 84,
              stroke: 9,
              value: overall.toDouble(),
              colors: const [Colors.white, Color(0xFFC9D2FF)],
              track: Colors.white24,
              center: Text('$overall%', style: jk(19, weight: FontWeight.w800, color: Colors.white)),
            ),
          ]),
        ),
        const SizedBox(height: 22),
        Text('By subject', style: jk(15, weight: FontWeight.w800)),
        const SizedBox(height: 12),
        ...kSubjects.map((s) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(children: [
                GradientTile(icon: s.icon, c1: s.c1, c2: s.c2, size: 40, radius: 12, iconSize: 19),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(s.name, style: jk(13.5, weight: FontWeight.w700)),
                      Text('${s.progress}%', style: jk(13.5, weight: FontWeight.w800, color: s.c2)),
                    ]),
                    const SizedBox(height: 7),
                    ProgressBar(value: s.progress.toDouble(), colors: [s.c1, s.c2]),
                  ]),
                ),
              ]),
            )),
      ],
    );
  }
}
