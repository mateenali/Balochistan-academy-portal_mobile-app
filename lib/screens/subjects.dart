import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets.dart';
import '../data.dart';
import 'subject_detail.dart';

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});
  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  String selectedClass = 'Class 10';
  final classes = ['Class 8', 'Class 9', 'Class 10', 'FSc-I', 'FSc-II'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: EdgeInsets.only(bottom: 100 + MediaQuery.of(context).viewPadding.bottom),
        children: [
          // header
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 8, 22, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('LIBRARY', style: jk(11.5, weight: FontWeight.w700, color: AppColors.ink3, spacing: 1.4)),
                const SizedBox(height: 6),
                Text('Subjects', style: jk(27, weight: FontWeight.w800, spacing: -0.5)),
                Text('مضامین', style: urdu(size: 17)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // class selector
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 22),
              itemCount: classes.length,
              separatorBuilder: (_, __) => const SizedBox(width: 9),
              itemBuilder: (_, i) {
                final c = classes[i];
                final active = c == selectedClass;
                return Pressable(
                  onTap: () => setState(() => selectedClass = c),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                    decoration: BoxDecoration(
                      color: active ? AppColors.ink : AppColors.surface,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: active ? AppColors.ink : AppColors.line),
                    ),
                    child: Text(c, style: jk(13, weight: FontWeight.w700, color: active ? Colors.white : AppColors.ink)),
                  ),
                );
              },
            ),
          ),

          // progress banner
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
            child: AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    ProgressRing(
                      size: 54, stroke: 7, value: 62,
                      center: Text('62%', style: jk(13, weight: FontWeight.w800)),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$selectedClass progress', style: jk(15, weight: FontWeight.w800)),
                        const SizedBox(height: 2),
                        Text('8 subjects · 64 lessons left', style: jk(12.5, weight: FontWeight.w600, color: AppColors.ink3)),
                      ],
                    ),
                  ]),
                  const Icon(Icons.bar_chart_rounded, color: AppColors.teal500, size: 22),
                ],
              ),
            ),
          ),

          // subject grid
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 14, crossAxisSpacing: 14, childAspectRatio: 0.82,
              ),
              itemCount: kSubjects.length,
              itemBuilder: (_, i) {
                final s = kSubjects[i];
                return AppCard(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 15),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => SubjectDetailScreen(subject: s),
                  )),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GradientTile(icon: s.icon, c1: s.c1, c2: s.c2, size: 48, radius: 15, iconSize: 23),
                      const SizedBox(height: 13),
                      Text(s.name, style: jk(15, weight: FontWeight.w800, spacing: -0.2)),
                      Text(s.urdu, style: urdu(size: 13)),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${s.lessons} lessons', style: jk(12.5, weight: FontWeight.w600, color: AppColors.ink3)),
                          Container(
                            width: 26, height: 26,
                            decoration: const BoxDecoration(color: AppColors.surfaceSunken, shape: BoxShape.circle),
                            child: const Icon(Icons.chevron_right_rounded, size: 15, color: AppColors.ink2),
                          ),
                        ],
                      ),
                    ],
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
