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

/// A single decorative symbol — a text glyph (e.g. 'x²'), an Urdu-script glyph, or an icon.
class _Sym {
  final String? text;
  final IconData? icon;
  final bool isUrdu;
  const _Sym.text(this.text) : icon = null, isUrdu = false;
  const _Sym.urdu(this.text) : icon = null, isUrdu = true;
  const _Sym.icon(this.icon) : text = null, isUrdu = false;
}

/// Where a decorative symbol sits in the hero, with its size, tilt and faintness.
class _Spot {
  final double? left, right, top, bottom;
  final double size, angle, opacity;
  const _Spot({this.left, this.right, this.top, this.bottom, required this.size, this.angle = 0, required this.opacity});
}

/// Fixed scatter positions reused for every subject's background symbols.
const _kSpots = [
  _Spot(right: 18, top: -2, size: 38, angle: 0.12, opacity: 0.20),
  _Spot(right: 104, top: 52, size: 22, angle: -0.18, opacity: 0.15),
  _Spot(right: 160, top: 8, size: 18, angle: 0.22, opacity: 0.13),
  _Spot(left: 150, bottom: 24, size: 30, angle: -0.12, opacity: 0.13),
  _Spot(left: 96, top: 30, size: 16, angle: 0.20, opacity: 0.11),
];

/// Subject-themed symbols keyed by Subject.key.
List<_Sym> _symbolsFor(String key) {
  switch (key) {
    case 'math':
      return const [_Sym.text('x²'), _Sym.text('√'), _Sym.text('π'), _Sym.text('∑'), _Sym.text('=')];
    case 'phy':
      return const [_Sym.text('F=ma'), _Sym.icon(Icons.bubble_chart), _Sym.text('Ω'), _Sym.text('λ'), _Sym.icon(Icons.bolt)];
    case 'chem':
      return const [_Sym.text('H₂O'), _Sym.icon(Icons.science), _Sym.text('CO₂'), _Sym.text('Na'), _Sym.icon(Icons.bubble_chart)];
    case 'bio':
      return const [_Sym.icon(Icons.spa), _Sym.icon(Icons.biotech), _Sym.text('DNA'), _Sym.icon(Icons.coronavirus), _Sym.icon(Icons.eco)];
    case 'eng':
      return const [_Sym.text('Aa'), _Sym.icon(Icons.format_quote), _Sym.icon(Icons.menu_book), _Sym.text('?'), _Sym.text('!')];
    case 'urdu':
      return const [_Sym.urdu('اردو'), _Sym.urdu('ا'), _Sym.urdu('ب'), _Sym.urdu('پ'), _Sym.urdu('ج')];
    case 'cs':
      return const [_Sym.text('</>'), _Sym.text('{ }'), _Sym.text('101'), _Sym.icon(Icons.terminal), _Sym.text(';')];
    case 'isl':
      return const [_Sym.icon(Icons.brightness_3), _Sym.icon(Icons.mosque), _Sym.icon(Icons.menu_book_rounded), _Sym.icon(Icons.auto_awesome), _Sym.icon(Icons.star_rounded)];
    default:
      return const [_Sym.icon(Icons.menu_book_rounded), _Sym.icon(Icons.lightbulb_outline), _Sym.icon(Icons.school)];
  }
}

/// Builds the faint, subject-themed glyphs scattered across the hero background.
List<Widget> _heroDecor(String key) {
  final symbols = _symbolsFor(key);
  final out = <Widget>[];
  for (var i = 0; i < symbols.length && i < _kSpots.length; i++) {
    final sym = symbols[i];
    final spot = _kSpots[i];
    out.add(Positioned(
      left: spot.left,
      right: spot.right,
      top: spot.top,
      bottom: spot.bottom,
      child: Transform.rotate(
        angle: spot.angle,
        child: sym.icon != null
            ? Icon(sym.icon, size: spot.size, color: Colors.white.withOpacity(spot.opacity))
            : Text(
                sym.text!,
                style: sym.isUrdu
                    ? urdu(size: spot.size, color: Colors.white.withOpacity(spot.opacity), weight: FontWeight.w700)
                    : jk(spot.size, weight: FontWeight.w800, color: Colors.white.withOpacity(spot.opacity)),
              ),
      ),
    ));
  }
  return out;
}

/// A chapter within a subject.
class _Chapter {
  final String title;
  const _Chapter(this.title);
}

/// Progress state of a chapter relative to where the student is up to.
enum _CState { completed, current, upcoming }

/// Chapter titles per subject, keyed by Subject.key.
List<_Chapter> _chaptersFor(String key) {
  const map = {
    'math': ['Real Numbers', 'Algebraic Expressions', 'Linear Equations', 'Quadratic Equations', 'Matrices & Determinants', 'Trigonometry'],
    'phy': ['Physical Quantities', 'Kinematics', 'Dynamics', 'Work & Energy', 'Waves & Sound', 'Electricity'],
    'chem': ['Atomic Structure', 'Periodic Table', 'Chemical Bonding', 'States of Matter', 'Acids & Bases', 'Organic Chemistry'],
    'bio': ['Cell Biology', 'Biomolecules', 'Enzymes', 'Photosynthesis', 'Genetics', 'Evolution'],
    'eng': ['Grammar Basics', 'Tenses', 'Comprehension', 'Essay Writing', 'Poetry', 'Vocabulary'],
    'urdu': ['Prose', 'Nazm', 'Ghazal', 'Grammar', 'Essay Writing', 'Story'],
    'cs': ['Intro to Computing', 'Number Systems', 'Programming Basics', 'Algorithms', 'Data Structures', 'Databases'],
    'isl': ['Quranic Studies', 'Hadith', 'Seerah', 'Islamic History', 'Fiqh', 'Ethics & Manners'],
  };
  final titles = map[key] ?? const ['Unit 1', 'Unit 2', 'Unit 3', 'Unit 4', 'Unit 5', 'Unit 6'];
  return titles.map(_Chapter.new).toList();
}

/// Builds the lesson list for a chapter, with completion markers reflecting its state.
List<_LessonItem> _chapterLessons(String title, _CState st) {
  switch (st) {
    case _CState.completed:
      return [
        _LessonItem('Introduction', '12 min · Video', done: true),
        _LessonItem('Core Concepts', '18 min · Video', done: true),
        _LessonItem('$title in Depth', '15 min · Video', done: true),
        _LessonItem('Worked Examples', '14 min · Reading', done: true),
        _LessonItem('Summary', '8 min · Reading', done: true),
        _LessonItem('Chapter Test', '10 questions', done: true, test: true),
      ];
    case _CState.current:
      return [
        _LessonItem('Introduction', '12 min · Video', done: true),
        _LessonItem('Core Concepts', '18 min · Video', done: true),
        _LessonItem('$title in Depth', '15 min · Video', active: true),
        _LessonItem('Worked Examples', '14 min · Reading'),
        _LessonItem('Summary', '8 min · Reading'),
        _LessonItem('Chapter Test', '10 questions', test: true),
      ];
    case _CState.upcoming:
      return [
        _LessonItem('Introduction', '12 min · Video'),
        _LessonItem('Core Concepts', '18 min · Video'),
        _LessonItem('$title in Depth', '15 min · Video'),
        _LessonItem('Worked Examples', '14 min · Reading'),
        _LessonItem('Summary', '8 min · Reading'),
        _LessonItem('Chapter Test', '10 questions', test: true),
      ];
  }
}

class SubjectDetailScreen extends StatefulWidget {
  final Subject subject;
  final bool readOnly;
  const SubjectDetailScreen({super.key, required this.subject, this.readOnly = false});

  @override
  State<SubjectDetailScreen> createState() => _SubjectDetailScreenState();
}

class _SubjectDetailScreenState extends State<SubjectDetailScreen> {
  late final List<_Chapter> _chapters = _chaptersFor(widget.subject.key);

  /// The chapter the student is currently up to — drives done/active markers.
  late final int _currentChapter = widget.readOnly
      ? _chapters.length
      : ((widget.subject.progress / 100) * _chapters.length).floor().clamp(0, _chapters.length - 1);

  late int _selected = _currentChapter.clamp(0, _chapters.length - 1);

  _CState _stateFor(int i) => (widget.readOnly || i < _currentChapter)
      ? _CState.completed
      : (i == _currentChapter ? _CState.current : _CState.upcoming);

  void _pickChapter() {
    final subject = widget.subject;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(width: 44, height: 5, decoration: BoxDecoration(color: AppColors.line, borderRadius: BorderRadius.circular(999))),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Row(
                  children: [
                    Text('Select chapter', style: jk(18, weight: FontWeight.w800)),
                    const Spacer(),
                    Text('${_chapters.length} chapters', style: jk(12.5, weight: FontWeight.w600, color: AppColors.ink3)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
                  itemCount: _chapters.length,
                  itemBuilder: (_, i) {
                    final st = _stateFor(i);
                    final sel = i == _selected;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Pressable(
                        onTap: () {
                          setState(() => _selected = i);
                          Navigator.of(sheetContext).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
                          decoration: BoxDecoration(
                            color: sel ? subject.c1.withOpacity(0.10) : AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: sel ? subject.c2 : AppColors.line, width: sel ? 1.5 : 1),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 36, height: 36,
                                decoration: BoxDecoration(
                                  color: st == _CState.completed
                                      ? AppColors.successBg
                                      : sel
                                          ? subject.c1.withOpacity(0.16)
                                          : AppColors.surfaceSunken,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  st == _CState.completed
                                      ? Icons.check_rounded
                                      : st == _CState.current
                                          ? Icons.play_arrow_rounded
                                          : Icons.menu_book_rounded,
                                  size: 18,
                                  color: st == _CState.completed
                                      ? AppColors.success
                                      : sel
                                          ? subject.c2
                                          : AppColors.ink3,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('CHAPTER ${i + 1}', style: jk(10.5, weight: FontWeight.w700, color: AppColors.ink3, spacing: 0.6)),
                                    const SizedBox(height: 1),
                                    Text(_chapters[i].title, style: jk(14.5, weight: FontWeight.w800)),
                                  ],
                                ),
                              ),
                              if (st == _CState.completed)
                                const Icon(Icons.check_circle_rounded, size: 18, color: AppColors.success)
                              else if (st == _CState.current)
                                Text('In progress', style: jk(11.5, weight: FontWeight.w700, color: subject.c2)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final subject = widget.subject;
    final readOnly = widget.readOnly;
    final lessons = _chapterLessons(_chapters[_selected].title, _stateFor(_selected));
    final doneCount = lessons.where((l) => l.done).length;

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
                  ..._heroDecor(subject.key),
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
                                const SizedBox(height: 6),
                                Text('Class 10 · ${subject.lessons} lessons', style: jk(13, weight: FontWeight.w600, color: Colors.white70)),
                                if (readOnly) ...[
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(999)),
                                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                                      const Icon(Icons.lock_open_rounded, size: 13, color: Colors.white),
                                      const SizedBox(width: 6),
                                      Text('Read-only · completed class', style: jk(11.5, weight: FontWeight.w700, color: Colors.white)),
                                    ]),
                                  ),
                                ],
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

          // chapter selector (dropdown)
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
            child: Pressable(
              onTap: _pickChapter,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.line),
                  boxShadow: cardShadow,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [subject.c1, subject.c2]),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Center(child: Text('${_selected + 1}', style: jk(16, weight: FontWeight.w800, color: Colors.white))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('CHAPTER ${_selected + 1}', style: jk(10.5, weight: FontWeight.w700, color: AppColors.ink3, spacing: 0.6)),
                          const SizedBox(height: 1),
                          Text(_chapters[_selected].title, style: jk(16, weight: FontWeight.w800, spacing: -0.2)),
                        ],
                      ),
                    ),
                    Text('$doneCount/${lessons.length}', style: jk(12.5, weight: FontWeight.w700, color: AppColors.teal600)),
                    const SizedBox(width: 8),
                    const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.ink2, size: 22),
                  ],
                ),
              ),
            ),
          ),

          // lesson list
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(22, 14, 22, 24 + MediaQuery.of(context).viewPadding.bottom),
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
                        if (readOnly) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text('Tests are disabled for completed classes',
                                  style: jk(13.5, weight: FontWeight.w700, color: Colors.white)),
                            ),
                          );
                          return;
                        }
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const QuizScreen()));
                      } else {
                        // Maths · Chapter 1 · Introduction → real video lesson
                        final videoId = (subject.key == 'math' && _selected == 0 && i == 0) ? 'vRAp1w3-BHg' : null;
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => LessonScreen(videoId: videoId)));
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
