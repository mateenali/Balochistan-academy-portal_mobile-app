import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets.dart';
import '../data.dart';

/// Parent / Teacher test — assign a graded test to a student.
class ParentTeacherTestScreen extends StatefulWidget {
  const ParentTeacherTestScreen({super.key});
  @override
  State<ParentTeacherTestScreen> createState() => _ParentTeacherTestScreenState();
}

class _ParentTeacherTestScreenState extends State<ParentTeacherTestScreen> {
  final _student = TextEditingController(text: 'Hadiya Baloch');
  int _subject = 0;
  String _due = 'Today';

  @override
  void dispose() {
    _student.dispose();
    super.dispose();
  }

  void _assign() {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.success,
        content: Text('Test assigned to ${_student.text} · ${kSubjects[_subject].name}', style: jk(13.5, weight: FontWeight.w700, color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: 'Parent / Teacher Test',
      bottom: PrimaryButton(label: 'Assign test', icon: Icons.send_rounded, onTap: _assign, colors: const [AppColors.violet, AppColors.violet2]),
      children: [
        AppCard(
          gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.violet, AppColors.violet2]),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(children: [
            const Orb(size: 46, color: Colors.white, shadow: Color(0x55142E3C), child: Icon(Icons.supervisor_account_rounded, color: AppColors.violet2, size: 24)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Set a graded test', style: jk(15, weight: FontWeight.w800, color: Colors.white)),
                const SizedBox(height: 2),
                Text('Results are saved to the student record', style: jk(12.5, weight: FontWeight.w600, color: Colors.white70)),
              ]),
            ),
          ]),
        ),
        const SizedBox(height: 22),
        Text('Student', style: jk(15, weight: FontWeight.w800)),
        const SizedBox(height: 10),
        AppCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          child: TextField(
            controller: _student,
            style: jk(14.5, weight: FontWeight.w700),
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: const Icon(Icons.person_rounded, color: AppColors.ink3, size: 20),
              hintText: 'Student name',
              hintStyle: jk(14.5, weight: FontWeight.w600, color: AppColors.ink3),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text('Subject', style: jk(15, weight: FontWeight.w800)),
        const SizedBox(height: 10),
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
                  gradient: sel ? LinearGradient(colors: [s.c1, s.c2]) : null,
                  color: sel ? null : AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: sel ? Colors.transparent : AppColors.line),
                  boxShadow: sel ? null : cardShadow,
                ),
                child: Text(s.name, style: jk(13, weight: FontWeight.w700, color: sel ? Colors.white : AppColors.ink)),
              ),
            );
          }),
        ),
        const SizedBox(height: 20),
        Text('Due', style: jk(15, weight: FontWeight.w800)),
        const SizedBox(height: 10),
        Row(
          children: ['Today', 'Tomorrow', 'This week'].map((d) {
            final sel = _due == d;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Pressable(
                  onTap: () => setState(() => _due = d),
                  child: Container(
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: sel ? AppColors.indigo50 : AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: sel ? AppColors.indigo400 : AppColors.line, width: sel ? 1.6 : 1),
                    ),
                    child: Text(d, style: jk(13, weight: FontWeight.w700, color: sel ? AppColors.indigo600 : AppColors.ink2)),
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
