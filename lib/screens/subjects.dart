import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets.dart';
import '../data.dart';
import '../Api/api_client.dart';
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

  // ── API: subjects for the logged-in user's grade ──
  final ApiClient _apiClient = ApiClient();
  Map<String, dynamic>? _user;
  List<Map<String, dynamic>> _subjects = [];
  bool _subjectsLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _subjectsLoading = true;
      _subjects = [];
    });
    try {
      final data = await _apiClient.getCurrentUser();
      _user = (data['user'] as Map?)?.cast<String, dynamic>() ?? data.cast<String, dynamic>();
      final code = _user?['gradeCode'];
      if (code == null || '$code'.trim().isEmpty) {
        // account has no grade → no subjects
        if (mounted) setState(() => _subjectsLoading = false);
        return;
      }
      final subjects = await _apiClient.getSubjectsForGrade('$code');
      if (!mounted) return;
      setState(() {
        _subjects = subjects;
        _subjectsLoading = false;
      });
    } catch (e) {
      print('Load Subjects Error: $e');
      if (!mounted) return;
      setState(() {
        _subjects = [];
        _subjectsLoading = false;
      });
    }
  }

  IconData _subjectIcon(String? name) {
    switch (name) {
      case 'calculator':
        return Icons.calculate_rounded;
      case 'book-open':
        return Icons.menu_book_rounded;
      case 'pen':
        return Icons.edit_rounded;
      case 'moon':
        return Icons.nightlight_round;
      case 'map':
        return Icons.map_rounded;
      case 'microscope':
        return Icons.science_rounded;
      case 'flask':
        return Icons.science_rounded;
      case 'atom':
        return Icons.bubble_chart_rounded;
      case 'leaf':
        return Icons.spa_rounded;
      case 'globe':
        return Icons.public_rounded;
      case 'code':
        return Icons.code_rounded;
      default:
        return Icons.menu_book_rounded;
    }
  }

  Color _hexColor(String? hex) {
    if (hex == null || hex.isEmpty) return AppColors.indigo500;
    var h = hex.replaceFirst('#', '').trim();
    if (h.length == 6) h = 'FF$h';
    final value = int.tryParse(h, radix: 16);
    return value == null ? AppColors.indigo500 : Color(value);
  }

  // Build a Subject (for the detail screen) from an API subject map.
  Subject _toSubject(Map<String, dynamic> m) {
    final color = _hexColor(m['color'] as String?);
    return Subject(
      m['id']?.toString() ?? (m['name'] as String? ?? 'subject'),
      (m['name'] as String?) ?? 'Subject',
      (m['nameUr'] as String?) ?? '',
      _subjectIcon(m['icon'] as String?),
      color,
      Color.lerp(color, Colors.black, 0.22)!,
      0,
      0,
    );
  }

  Widget _subjectCard(BuildContext context, Map<String, dynamic> m) {
    final color = _hexColor(m['color'] as String?);
    final dark = Color.lerp(color, Colors.black, 0.22)!;
    final name = (m['name'] as String?) ?? 'Subject';
    final done = viewingCompleted;
    return AppCard(
      clip: true,
      padding: EdgeInsets.zero,
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => SubjectDetailScreen(subject: _toSubject(m), readOnly: viewingCompleted),
      )),
      child: Stack(
        children: [
          // soft accent wash tinted by the subject colour
          Positioned(
            right: -26, top: -26,
            child: Container(
              width: 88, height: 88,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(0.10)),
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
                    GradientTile(icon: _subjectIcon(m['icon'] as String?), c1: color, c2: dark, size: 46, radius: 15, iconSize: 22),
                    if (done)
                      Container(
                        width: 26, height: 26,
                        decoration: const BoxDecoration(color: AppColors.successBg, shape: BoxShape.circle),
                        child: const Icon(Icons.check_rounded, size: 15, color: AppColors.success),
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(name, style: jk(15.5, weight: FontWeight.w800, spacing: -0.2)),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      done ? 'Completed' : 'Open',
                      style: jk(12.5, weight: FontWeight.w700, color: done ? AppColors.success : dark),
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
          if (_subjects.isNotEmpty)
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
          if (_subjects.isNotEmpty)
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
          if (_subjectsLoading)
            const Padding(
              padding: EdgeInsets.only(top: 60),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_subjects.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 50, 22, 0),
              child: Center(
                child: Column(
                  children: [
                    const Icon(Icons.menu_book_outlined, size: 44, color: AppColors.ink3),
                    const SizedBox(height: 12),
                    Text('No subjects available', style: jk(15, weight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text('Your account has no grade assigned yet',
                        textAlign: TextAlign.center,
                        style: jk(12.5, weight: FontWeight.w600, color: AppColors.ink3)),
                  ],
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 14, crossAxisSpacing: 14, childAspectRatio: 0.95,
                ),
                itemCount: _subjects.length,
                itemBuilder: (_, i) => _subjectCard(context, _subjects[i]),
              ),
            ),
        ],
      ),
    );
  }
}
