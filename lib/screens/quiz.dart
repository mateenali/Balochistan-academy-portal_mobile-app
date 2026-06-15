import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets.dart';

class _QuizQuestion {
  final String question;
  final String urdu;
  final List<String> options;
  final int answer;
  const _QuizQuestion(this.question, this.urdu, this.options, this.answer);
}

const _questions = [
  _QuizQuestion('What is the standard form of a quadratic equation?',
      'درجہ دوم کی مساوات کی معیاری شکل کیا ہے؟',
      ['ax + b = 0', 'ax² + bx + c = 0', 'ax³ + bx = c', 'a/x + b = 0'], 1),
  _QuizQuestion('The discriminant of ax² + bx + c is:',
      '',
      ['b² − 4ac', '2a + b', '4ac − b²', 'a² + b²'], 0),
  _QuizQuestion('If discriminant > 0, the roots are:',
      '',
      ['Equal & real', 'No real roots', 'Two distinct real roots', 'Imaginary only'], 2),
];

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _index = 0;
  int? _selected;
  int _score = 0;
  bool _done = false;

  void _choose(int k) {
    if (_selected != null) return;
    setState(() {
      _selected = k;
      if (k == _questions[_index].answer) _score++;
    });
  }

  void _next() {
    if (_index + 1 < _questions.length) {
      setState(() { _index++; _selected = null; });
    } else {
      setState(() => _done = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_done) return _buildResult();
    final q = _questions[_index];
    final answered = _selected != null;

    return Scaffold(
      body: Column(
        children: [
          // header
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 58, 22, 10),
            child: Row(
              children: [
                Pressable(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), boxShadow: cardShadow),
                    child: const Icon(Icons.arrow_back_rounded, size: 20, color: AppColors.ink),
                  ),
                ),
                const SizedBox(width: 12),
                Text('Quiz', style: jk(17, weight: FontWeight.w700, spacing: -0.2)),
                const Spacer(),
                Text('${_index + 1}/${_questions.length}', style: jk(14, weight: FontWeight.w800, color: AppColors.teal600)),
              ],
            ),
          ),

          // progress bar
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 6, 22, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (_index + 1) / _questions.length,
                minHeight: 5,
                backgroundColor: AppColors.surfaceSunken,
                valueColor: const AlwaysStoppedAnimation(AppColors.teal500),
              ),
            ),
          ),

          // question
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
              children: [
                Text(q.question, style: jk(20, weight: FontWeight.w800, spacing: -0.3)),
                const SizedBox(height: 24),

                // options
                ...q.options.asMap().entries.map((e) {
                  final k = e.key;
                  final v = e.value;
                  final isCorrect = k == q.answer;
                  final isSelected = k == _selected;
                  Color bg = AppColors.surface;
                  Color border = AppColors.line;
                  if (answered) {
                    if (isCorrect) {
                      bg = AppColors.successBg;
                      border = AppColors.success;
                    } else if (isSelected) {
                      bg = const Color(0xFFFFF0F0);
                      border = AppColors.coral;
                    }
                  }

                  final content = AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: border, width: answered ? 1.5 : 1),
                      boxShadow: answered && isCorrect ? [BoxShadow(color: AppColors.success.withOpacity(0.3), blurRadius: 12, spreadRadius: -4)] : null,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 30, height: 30,
                          decoration: BoxDecoration(
                            color: answered && isCorrect ? AppColors.success : answered && isSelected ? AppColors.coral : AppColors.surfaceSunken,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: answered && isCorrect
                                ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                                : answered && isSelected
                                    ? const Icon(Icons.close_rounded, color: Colors.white, size: 16)
                                    : Text(String.fromCharCode(65 + k), style: jk(13, weight: FontWeight.w800, color: AppColors.ink2)),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(child: Text(v, style: jk(15, weight: FontWeight.w600))),
                      ],
                    ),
                  );

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: answered ? content : Pressable(onTap: () => _choose(k), child: content),
                  );
                }),
              ],
            ),
          ),

          // next button
          if (answered)
            Padding(
              padding: EdgeInsets.fromLTRB(22, 8, 22, 24 + MediaQuery.of(context).viewPadding.bottom),
              child: Pressable(
                onTap: _next,
                child: Container(
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.indigo400, AppColors.indigo600]),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [BoxShadow(color: AppColors.indigo600.withOpacity(0.7), blurRadius: 24, offset: const Offset(0, 12), spreadRadius: -10)],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_index + 1 < _questions.length ? 'Next question' : 'See results', style: jk(16, weight: FontWeight.w700, color: Colors.white)),
                      const SizedBox(width: 9),
                      const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    final pct = (_score / _questions.length * 100).round();
    final isGood = pct >= 60;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatY(
                child: Orb(
                  size: 132,
                  color: isGood ? AppColors.teal400 : AppColors.apricot,
                  shadow: isGood ? const Color(0x800D8979) : const Color(0x80F0742E),
                  child: Icon(
                    isGood ? Icons.emoji_events : Icons.refresh_rounded,
                    size: 56,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text('Quiz Complete!', style: jk(26, weight: FontWeight.w800, spacing: -0.5)),
              const SizedBox(height: 8),
              Text('$_score out of ${_questions.length} correct',
                  style: jk(15, weight: FontWeight.w600, color: AppColors.ink2)),
              const SizedBox(height: 6),
              Text('$pct%', style: jk(48, weight: FontWeight.w800, color: isGood ? AppColors.teal600 : AppColors.apricot2, spacing: -1)),
              Text(isGood ? 'Great job! 🎉' : 'Keep practicing! 💪',
                  style: jk(16, weight: FontWeight.w700, color: AppColors.ink2)),
              const SizedBox(height: 32),
              Pressable(
                onTap: () {
                  setState(() {
                    _index = 0;
                    _selected = null;
                    _score = 0;
                    _done = false;
                  });
                },
                child: Container(
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.teal500, AppColors.teal600]),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [BoxShadow(color: AppColors.teal600.withOpacity(0.7), blurRadius: 24, offset: const Offset(0, 12), spreadRadius: -10)],
                  ),
                  child: Center(child: Text('Try Again', style: jk(16, weight: FontWeight.w700, color: Colors.white))),
                ),
              ),
              const SizedBox(height: 14),
              Pressable(
                onTap: () => Navigator.of(context).pop(),
                child: Text('Go back', style: jk(14, weight: FontWeight.w700, color: AppColors.ink3)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
