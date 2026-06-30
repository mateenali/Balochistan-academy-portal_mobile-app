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
  final classes = ['Class 8', 'Class 9', 'Class 10', 'FSc-I', 'FSc-II'];

  /// The single class the student is currently enrolled in.
  /// Classes before it are completed (read-only); classes after it are locked.
  static const int enrolledIndex = 2;
  int selectedIndex = enrolledIndex;

  String get selectedClass => classes[selectedIndex];
  bool get viewingCompleted => selectedIndex < enrolledIndex;

  Widget _subjectCard(BuildContext context, Subject s) {
    final done = s.progress >= 100 || viewingCompleted;
    return AppCard(
      clip: true,
      padding: EdgeInsets.zero,
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => SubjectDetailScreen(subject: s, readOnly: viewingCompleted),
      )),
      child: Stack(
        children: [
          // soft accent wash tinted by the subject colour
          Positioned(
            right: -26, top: -26,
            child: Container(
              width: 88, height: 88,
              decoration: BoxDecoration(shape: BoxShape.circle, color: s.c1.withOpacity(0.10)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GradientTile(icon: s.icon, c1: s.c1, c2: s.c2, size: 46, radius: 15, iconSize: 22),
                    done
                        ? Container(
                            width: 26, height: 26,
                            decoration: const BoxDecoration(color: AppColors.successBg, shape: BoxShape.circle),
                            child: const Icon(Icons.check_rounded, size: 15, color: AppColors.success),
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                            decoration: BoxDecoration(color: s.c1.withOpacity(0.14), borderRadius: BorderRadius.circular(999)),
                            child: Text('${s.progress}%', style: jk(11.5, weight: FontWeight.w800, color: s.c2)),
                          ),
                  ],
                ),
                const SizedBox(height: 13),
                Text(s.name, style: jk(15.5, weight: FontWeight.w800, spacing: -0.2)),
                const SizedBox(height: 3),
                Text('${s.lessons} lessons', style: jk(12.5, weight: FontWeight.w600, color: AppColors.ink3)),
                const Spacer(),
                ProgressBar(value: done ? 100 : s.progress.toDouble(), colors: [s.c1, s.c2], height: 6),
                const SizedBox(height: 9),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      done ? 'Completed' : 'Continue',
                      style: jk(12, weight: FontWeight.w700, color: done ? AppColors.success : s.c2),
                    ),
                    Icon(done ? Icons.visibility_rounded : Icons.arrow_forward_rounded, size: 15, color: AppColors.ink3),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _lockedToast() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Locked — finish ${classes[enrolledIndex]} to unlock this class',
            style: jk(13.5, weight: FontWeight.w700, color: Colors.white)),
      ),
    );
  }

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
                final selected = i == selectedIndex;
                final completed = i < enrolledIndex;
                final locked = i > enrolledIndex;
                final fg = selected ? Colors.white : (locked ? AppColors.ink3 : AppColors.ink);
                return Pressable(
                  onTap: locked ? _lockedToast : () => setState(() => selectedIndex = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.ink : AppColors.surface,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: selected ? AppColors.ink : AppColors.line),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (completed) ...[
                          Icon(Icons.check_circle_rounded, size: 14, color: selected ? Colors.white : AppColors.success),
                          const SizedBox(width: 6),
                        ] else if (locked) ...[
                          const Icon(Icons.lock_rounded, size: 13, color: AppColors.ink3),
                          const SizedBox(width: 6),
                        ],
                        Text(c, style: jk(13, weight: FontWeight.w700, color: fg)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // status banner — read-only for completed classes, progress for the enrolled one
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
            child: viewingCompleted
                ? AppCard(
                    color: AppColors.surfaceSunken,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Container(
                          width: 42, height: 42,
                          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(13)),
                          child: const Icon(Icons.lock_open_rounded, color: AppColors.ink2, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('$selectedClass · Completed', style: jk(15, weight: FontWeight.w800)),
                              const SizedBox(height: 2),
                              Text('Read-only — review lessons, but tests are disabled', style: jk(12.5, weight: FontWeight.w600, color: AppColors.ink3)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : AppCard(
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
                              Row(children: [
                                Text('$selectedClass progress', style: jk(15, weight: FontWeight.w800)),
                                const SizedBox(width: 8),
                                Chip2('Enrolled', bg: AppColors.successBg, fg: AppColors.success),
                              ]),
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
                crossAxisCount: 2, mainAxisSpacing: 14, crossAxisSpacing: 14, childAspectRatio: 0.76,
              ),
              itemCount: kSubjects.length,
              itemBuilder: (_, i) => _subjectCard(context, kSubjects[i]),
            ),
          ),
        ],
      ),
    );
  }
}
