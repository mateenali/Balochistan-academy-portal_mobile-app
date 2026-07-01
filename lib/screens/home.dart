import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets.dart';
import '../Api/api_client.dart';
import 'lesson.dart';
import 'quiz.dart';
import 'full_syllabus.dart';
import 'self_test.dart';
import 'parent_teacher_test.dart';
import 'test_records.dart';
import 'daily_test.dart';
import 'monthly_test.dart';
import 'result_reports.dart';
import 'complaints.dart';


class HomeScreen extends StatefulWidget {
  final ValueChanged<int> onTab;
  const HomeScreen({super.key, required this.onTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiClient _apiClient = ApiClient();
  Map<String, dynamic>? _user; // from GET /api/auth/me
  bool _profileLoading = true;

  // subjects for the user's grade — from GET /api/grades/{code}/subjects
  List<Map<String, dynamic>> _subjects = [];
  bool _subjectsLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _profileLoading = true;
      _subjectsLoading = true;
      _subjects = []; // clear any stale subjects from a previous session
    });
    try {
      final data = await _apiClient.getCurrentUser();
      if (!mounted) return;
      setState(() {
        _user = (data['user'] as Map?)?.cast<String, dynamic>() ?? data.cast<String, dynamic>();
        _profileLoading = false;
      });
      _loadSubjects();
    } catch (e) {
      print('Load Profile Error: $e');
      if (!mounted) return;
      setState(() {
        _profileLoading = false;
        _subjectsLoading = false;
      });
    }
  }

  Future<void> _loadSubjects() async {
    final code = _user?['gradeCode'];
    if (code == null || '$code'.trim().isEmpty) {
      // no grade on the account → nothing to show
      if (mounted) {
        setState(() {
          _subjects = [];
          _subjectsLoading = false;
        });
      }
      return;
    }
    setState(() => _subjectsLoading = true);
    try {
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

  // Map an API icon name to a Material icon.
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

  // Parse a hex colour like "#3B82F6" into a Color.
  Color _hexColor(String? hex) {
    if (hex == null || hex.isEmpty) return AppColors.indigo500;
    var h = hex.replaceFirst('#', '').trim();
    if (h.length == 6) h = 'FF$h';
    final value = int.tryParse(h, radix: 16);
    return value == null ? AppColors.indigo500 : Color(value);
  }

  String get _name => (_user?['name'] as String?)?.trim().isNotEmpty == true
      ? _user!['name'] as String
      : (_user?['username'] as String? ?? 'Student');

  String get _initials {
    final parts = _name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }

  void onTab(int i) => widget.onTab(i);

  void _push(BuildContext c, Widget w) => Navigator.of(c).push(MaterialPageRoute(builder: (_) => w));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: EdgeInsets.only(bottom: 130 + MediaQuery.of(context).viewPadding.bottom),
        children: [
          // greeting
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 8, 22, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Assalam-o-Alaikum 👋', style: jk(12.5, weight: FontWeight.w700, color: AppColors.ink3)),
                  const SizedBox(height: 2),
                  Text(_profileLoading ? 'Loading…' : _name, style: jk(21, weight: FontWeight.w800, spacing: -0.3)),
                ]),
                Row(children: [
                  _iconBtn(Icons.notifications_none_rounded, dot: true),
                  const SizedBox(width: 8),
                  Pressable(
                    onTap: () => onTab(4),
                    child: Container(
                      width: 44, height: 44,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFFFD9B8), AppColors.apricot]),
                        boxShadow: cardShadow,
                      ),
                      child: Center(child: Text(_profileLoading ? '…' : _initials, style: jk(16, weight: FontWeight.w800, color: Colors.white))),
                    ),
                  ),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 14),
          // search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: AppCard(
              radius: 18,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              onTap: () => onTab(2),
              child: Row(children: [
                const Icon(Icons.search_rounded, color: AppColors.ink3, size: 20),
                const SizedBox(width: 12),
                Text('Ask eStudy AI anything…', style: jk(14.5, weight: FontWeight.w600, color: AppColors.ink3)),
              ]),
            ),
          ),
          const SizedBox(height: 18),
          // continue learning
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: AppCard(
              clip: true,
              padding: EdgeInsets.zero,
              gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF3A42C9), AppColors.indigo500]),
              onTap: () => _push(context, const LessonScreen()),
              child: Stack(children: [
                Positioned(right: -30, top: -30, child: _circle(150, 0.10)),
                Positioned(right: 30, bottom: -40, child: _circle(90, 0.08)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('CONTINUE LEARNING', style: jk(11.5, weight: FontWeight.w700, color: Colors.white70, spacing: 0.8)),
                          const SizedBox(height: 7),
                          Text('Quadratic Equations', style: jk(19, weight: FontWeight.w800, color: Colors.white)),
                          const SizedBox(height: 2),
                          Text('Mathematics · Lesson 6 of 12', style: jk(13, weight: FontWeight.w600, color: Colors.white70)),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(999)),
                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                              const Icon(Icons.play_arrow_rounded, size: 18, color: Color(0xFF3A42C9)),
                              const SizedBox(width: 6),
                              Text('Resume', style: jk(13.5, weight: FontWeight.w800, color: const Color(0xFF3A42C9))),
                            ]),
                          ),
                        ]),
                      ),
                      ProgressRing(
                        size: 84, stroke: 9, value: 48,
                        colors: const [Colors.white, Color(0xFFC9D2FF)],
                        track: Colors.white24,
                        center: Text('48%', style: jk(20, weight: FontWeight.w800, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 26),
          _sectionTitle('Test stats'),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: LayoutBuilder(
              builder: (context, c) {
                const gap = 11.0;
                final w = (c.maxWidth - gap) / 2;
                final cards = <Widget>[
                  _statCard(Icons.fact_check_rounded, '24', 'Total tests', AppColors.indigo400, AppColors.indigo600),
                  _statCard(Icons.verified_rounded, '19', 'Passed', AppColors.teal400, AppColors.teal600),
                  _statCard(Icons.insights_rounded, '74%', 'Avg score', AppColors.sky, AppColors.sky2),
                  _statCard(Icons.percent_rounded, '79%', 'Pass rate', AppColors.lime, AppColors.lime2),
                  _statCard(Icons.calendar_month_rounded, '6', 'This month', AppColors.apricot, AppColors.apricot2),
                ];
                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: cards.map((x) => SizedBox(width: w, child: x)).toList(),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          _sectionTitle('Quick actions'),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: LayoutBuilder(
              builder: (context, c) {
                const gap = 12.0;
                final w = (c.maxWidth - gap * 3) / 4;
                final actions = <Widget>[
                  _quick(Icons.menu_book_rounded, AppColors.indigo400, AppColors.indigo600, 'Full Syllabus', () => _push(context, const FullSyllabusScreen())),
                  _quick(Icons.edit_note_rounded, AppColors.violet, AppColors.rose2, 'Self Test', () => _push(context, const SelfTestScreen())),
                  _quick(Icons.supervisor_account_rounded, AppColors.violet, AppColors.violet2, 'Parent/Teacher Test', () => _push(context, const ParentTeacherTestScreen())),
                  _quick(Icons.history_rounded, AppColors.sky, AppColors.sky2, 'Test Records', () => _push(context, const TestRecordsScreen())),
                  _quick(Icons.today_rounded, AppColors.apricot, AppColors.apricot2, 'Daily Test', () => _push(context, const DailyTestScreen())),
                  _quick(Icons.calendar_month_rounded, AppColors.rose, AppColors.rose2, 'Monthly Test', () => _push(context, const MonthlyTestScreen())),
                  _quick(Icons.assessment_rounded, AppColors.lime, AppColors.lime2, 'Result Reports', () => _push(context, const ResultReportsScreen())),
                  _quick(Icons.report_problem_rounded, AppColors.coral, AppColors.rose2, 'Complaints', () => _push(context, const ComplaintsScreen())),

                ];
                return Wrap(
                  spacing: gap,
                  runSpacing: 18,
                  children: actions.map((a) => SizedBox(width: w, child: a)).toList(),
                );
              },
            ),
          ),
          const SizedBox(height: 26),
          _sectionTitle("Today's plan", trailing: '2 of 4 done'),
          const SizedBox(height: 12),
          ..._plan(context),
          const SizedBox(height: 26),
          _sectionTitle('Explore subjects', trailing: 'See all', onTrailing: () => onTab(1)),
          const SizedBox(height: 14),
          SizedBox(
            height: 96,
            child: _subjectsLoading
                ? const Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)))
                : _subjects.isEmpty
                    ? Center(
                        child: Text('No subjects available', style: jk(13, weight: FontWeight.w600, color: AppColors.ink3)),
                      )
                    : ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        itemCount: _subjects.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 14),
                        itemBuilder: (_, k) {
                          final s = _subjects[k];
                          final color = _hexColor(s['color'] as String?);
                          final name = (s['name'] as String?) ?? 'Subject';
                          return Pressable(
                            onTap: () => onTab(1),
                            child: Column(children: [
                              GradientTile(
                                icon: _subjectIcon(s['icon'] as String?),
                                c1: color,
                                c2: Color.lerp(color, Colors.black, 0.22)!,
                                size: 62, radius: 20, iconSize: 28,
                              ),
                              const SizedBox(height: 8),
                              Text(name.split(' ').first, style: jk(11.5, weight: FontWeight.w700, color: AppColors.ink2)),
                            ]),
                          );
                        },
                      ),
          ),
          const SizedBox(height: 20),
          // streak
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: AppCard(
              gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.white, Color(0xFFFFF7EE)]),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Row(children: [
                FloatY(
                  distance: 8,
                  child: const Orb(size: 52, color: AppColors.apricot, shadow: Color(0x80FF7828), child: Icon(Icons.local_fire_department, color: Colors.white, size: 26)),
                ),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('7-day streak 🔥', style: jk(16, weight: FontWeight.w800)),
                  Text('Study today to keep it alive', style: jk(12.5, weight: FontWeight.w600, color: AppColors.ink3)),
                ])),
                const Icon(Icons.chevron_right_rounded, color: AppColors.ink3),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circle(double s, double o) => Container(width: s, height: s, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(o)));

  Widget _iconBtn(IconData icon, {bool dot = false}) {
    return Container(
      width: 44, height: 44,
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), boxShadow: cardShadow),
      child: Stack(alignment: Alignment.center, children: [
        Icon(icon, size: 21, color: AppColors.ink),
        if (dot) Positioned(top: 11, right: 12, child: Container(width: 8, height: 8, decoration: BoxDecoration(color: AppColors.coral, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)))),
      ]),
    );
  }

  Widget _statCard(IconData icon, String value, String label, Color c1, Color c2) {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
      child: Row(
        children: [
          GradientTile(icon: icon, c1: c1, c2: c2, size: 42, radius: 13, iconSize: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: jk(20, weight: FontWeight.w800)),
                Text(label, style: jk(12, weight: FontWeight.w600, color: AppColors.ink3)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quick(IconData icon, Color c1, Color c2, String label, VoidCallback onTap) {
    return Pressable(
      onTap: onTap,
      child: Column(children: [
        GradientTile(icon: icon, c1: c1, c2: c2, size: 60, radius: 18, iconSize: 24),
        const SizedBox(height: 7),
        SizedBox(
          height: 28,
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: jk(11, weight: FontWeight.w700, color: AppColors.ink2, height: 1.15),
          ),
        ),
      ]),
    );
  }

  Widget _sectionTitle(String title, {String? trailing, VoidCallback? onTrailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(title, style: jk(17, weight: FontWeight.w700, spacing: -0.2)),
          if (trailing != null)
            Pressable(onTap: onTrailing ?? () {}, child: Text(trailing, style: jk(12.5, weight: FontWeight.w700, color: AppColors.teal600))),
        ],
      ),
    );
  }

  List<Widget> _plan(BuildContext context) {
    final items = [
      [true, Icons.functions, AppColors.indigo400, AppColors.indigo600, 'Algebra practice set', 'Maths · 15 min'],
      [true, Icons.science, AppColors.teal400, AppColors.teal600, 'Read: Acids & Bases', 'Chemistry · 10 min'],
      [false, Icons.menu_book, AppColors.apricot, AppColors.apricot2, 'Essay — My Province', 'English · 20 min'],
      [false, Icons.edit_rounded, AppColors.rose, AppColors.rose2, 'Vocabulary quiz', 'Urdu · 8 min'],
    ];
    return items.map((it) {
      final done = it[0] as bool;
      return Padding(
        padding: const EdgeInsets.fromLTRB(22, 0, 22, 12),
        child: Opacity(
          opacity: done ? 0.7 : 1,
          child: AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
            onTap: () => done ? null : Navigator.of(context).push(MaterialPageRoute(builder: (_) => it[4] == 'Vocabulary quiz' ? const QuizScreen() : const LessonScreen())),
            child: Row(children: [
              GradientTile(icon: it[1] as IconData, c1: it[2] as Color, c2: it[3] as Color, size: 42, radius: 13, iconSize: 20),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(it[4] as String, style: jk(14.5, weight: FontWeight.w700, color: AppColors.ink).copyWith(decoration: done ? TextDecoration.lineThrough : null)),
                const SizedBox(height: 1),
                Text(it[5] as String, style: jk(12.5, weight: FontWeight.w600, color: AppColors.ink3)),
              ])),
              Container(
                width: 26, height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done ? AppColors.successBg : Colors.transparent,
                  border: done ? null : Border.all(color: AppColors.line, width: 2),
                ),
                child: done ? const Icon(Icons.check_rounded, size: 15, color: AppColors.success) : null,
              ),
            ]),
          ),
        ),
      );
    }).toList();
  }
}
