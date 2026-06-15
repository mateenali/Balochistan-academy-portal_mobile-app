import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets.dart';
import 'quiz.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key});
  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  bool _playing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.only(bottom: 24 + MediaQuery.of(context).padding.bottom),
        children: [
          // video area
          Stack(
            children: [
              Container(
                height: 230,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                    colors: [Color(0xFF3A42C9), AppColors.indigo500, AppColors.teal500],
                    stops: [0, 0.55, 1],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(child: Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(center: const Alignment(-0.4, -0.4), radius: 0.8, colors: [Colors.white.withOpacity(0.2), Colors.transparent]),
                      ),
                    )),
                    // floating formula chips
                    Positioned(
                      top: 80, left: 40,
                      child: Text('x² + bx + c', style: jk(20, weight: FontWeight.w800, color: Colors.white38)),
                    ),
                    Positioned(
                      bottom: 70, right: 34,
                      child: Text('a≠0', style: jk(16, weight: FontWeight.w800, color: Colors.white30)),
                    ),
                    // play button
                    Center(
                      child: Pressable(
                        onTap: () => setState(() => _playing = !_playing),
                        child: Container(
                          width: 72, height: 72,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 30, offset: const Offset(0, 12), spreadRadius: -8)],
                          ),
                          child: Icon(
                            _playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            size: 32,
                            color: AppColors.indigo600,
                          ),
                        ),
                      ),
                    ),
                    // back button
                    Positioned(
                      top: 54, left: 18,
                      child: Pressable(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(14)),
                          child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                    // scrubber
                    Positioned(
                      bottom: 14, left: 18, right: 18,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: _playing ? 0.46 : 0.30,
                              minHeight: 4,
                              backgroundColor: Colors.white24,
                              valueColor: const AlwaysStoppedAnimation(Colors.white),
                            ),
                          ),
                          const SizedBox(height: 7),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_playing ? '5:42' : '3:48', style: jk(11, weight: FontWeight.w700, color: Colors.white)),
                              Text('12:30', style: jk(11, weight: FontWeight.w700, color: Colors.white)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // content
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // chips
                Row(
                  children: [
                    const Chip2('Mathematics', bg: AppColors.indigo50, fg: AppColors.indigo600),
                    const SizedBox(width: 8),
                    const Chip2('Lesson 6/12'),
                  ],
                ),
                const SizedBox(height: 10),
                Text('Quadratic Equations', style: jk(21, weight: FontWeight.w800, spacing: -0.3)),

                // AI summary card
                const SizedBox(height: 18),
                AppCard(
                  padding: const EdgeInsets.all(16),
                  gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.white, Color(0xFFEEF0FF)]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Orb(size: 32, color: AppColors.indigo400, shadow: Color(0x66454DD4),
                              child: Icon(Icons.auto_awesome, size: 16, color: Colors.white)),
                          const SizedBox(width: 8),
                          Text('AI Summary', style: jk(14, weight: FontWeight.w800)),
                          const Spacer(),
                          Text('Auto-generated', style: jk(12.5, weight: FontWeight.w600, color: AppColors.ink3)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      RichText(
                        text: TextSpan(
                          style: jk(13.5, weight: FontWeight.w500, color: AppColors.ink2, height: 1.5),
                          children: [
                            const TextSpan(text: 'A quadratic equation has the form '),
                            TextSpan(text: 'ax² + bx + c = 0', style: jk(13.5, weight: FontWeight.w800, color: AppColors.ink)),
                            const TextSpan(text: '. You can solve it three ways: factorisation, completing the square, or the quadratic formula. The discriminant b²−4ac tells you how many real roots exist.'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 13),
                      Row(
                        children: [
                          Pressable(
                            onTap: () {
                              // Navigate to tutor tab
                              Navigator.of(context).popUntil((route) => route.isFirst);
                            },
                            child: const Chip2('Ask about this', bg: AppColors.indigo500, fg: Colors.white, icon: Icons.chat_bubble_rounded),
                          ),
                          const SizedBox(width: 8),
                          Pressable(
                            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const QuizScreen())),
                            child: const Chip2('Quiz me', icon: Icons.edit_rounded),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // in this lesson
                const SizedBox(height: 24),
                Text('In this lesson', style: jk(17, weight: FontWeight.w700, spacing: -0.2)),
                const SizedBox(height: 12),
                ...['Standard form & coefficients', 'Solving by factorisation', 'The quadratic formula', 'Nature of roots (discriminant)']
                    .asMap().entries.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AppCard(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                    child: Row(
                      children: [
                        Container(
                          width: 24, height: 24,
                          decoration: const BoxDecoration(color: AppColors.surfaceSunken, shape: BoxShape.circle),
                          child: Center(child: Text('${e.key + 1}', style: jk(12, weight: FontWeight.w800, color: AppColors.ink2))),
                        ),
                        const SizedBox(width: 12),
                        Text(e.value, style: jk(14, weight: FontWeight.w600)),
                      ],
                    ),
                  ),
                )),

                // take quiz
                const SizedBox(height: 22),
                Pressable(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const QuizScreen())),
                  child: Container(
                    height: 54,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.teal500, AppColors.teal600]),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [BoxShadow(color: AppColors.teal600.withOpacity(0.7), blurRadius: 24, offset: const Offset(0, 12), spreadRadius: -10)],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Take the quiz', style: jk(16, weight: FontWeight.w700, color: Colors.white)),
                        const SizedBox(width: 9),
                        const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
