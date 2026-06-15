import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets.dart';
import 'photo_solve.dart';

class _ChatMsg {
  final bool isMe;
  final String text;
  final List<String>? steps;
  const _ChatMsg({required this.isMe, required this.text, this.steps});
}

class TutorScreen extends StatefulWidget {
  const TutorScreen({super.key});
  @override
  State<TutorScreen> createState() => _TutorScreenState();
}

class _TutorScreenState extends State<TutorScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _started = false;
  bool _typing = false;

  final List<_ChatMsg> _msgs = [
    const _ChatMsg(
      isMe: false,
      text: "Assalam-o-Alaikum, Hadiya! I'm your eStudy tutor. Ask me anything — maths, science, English — in English or Urdu. 🌟",
    ),
  ];

  void _send(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _started = true;
      _msgs.add(_ChatMsg(isMe: true, text: text));
      _typing = true;
    });
    _controller.clear();
    _scrollDown();

    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      setState(() {
        _typing = false;
        _msgs.add(_ChatMsg(
          isMe: false,
          text: "Great question! Let's break it down step by step:",
          steps: [
            'A quadratic is ax² + bx + c = 0 (a ≠ 0).',
            'Identify a, b, c from your equation.',
            'Use x = (−b ± √(b²−4ac)) / 2a to find the roots.',
          ],
        ));
      });
      _scrollDown();
    });
  }

  void _scrollDown() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    return Column(
      children: [
        // header
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 58, 22, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('eStudy AI', style: jk(17, weight: FontWeight.w700, spacing: -0.2)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                decoration: BoxDecoration(color: AppColors.successBg, borderRadius: BorderRadius.circular(999)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 7, height: 7, decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Text('Online', style: jk(12, weight: FontWeight.w800, color: AppColors.success)),
                  ],
                ),
              ),
            ],
          ),
        ),

        // messages
        Expanded(
          child: ListView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(22, 6, 22, 8),
            children: [
              if (!_started) _buildOrb(),

              ..._msgs.map((m) => _buildMsg(m)),

              if (_typing) _buildTyping(),
            ],
          ),
        ),

        // starter chips
        if (!_started)
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 6),
            child: Row(
              children: [
                _starterChip(Icons.camera_alt_rounded, 'Photo-solve', AppColors.teal400, AppColors.teal600,
                    () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PhotoSolveScreen()))),
                const SizedBox(width: 10),
                _starterChip(Icons.picture_as_pdf_rounded, 'Summarise notes', AppColors.rose, AppColors.rose2,
                    () => _send('Help me summarise notes')),
              ],
            ),
          ),
        if (!_started)
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 6),
            child: Row(
              children: [
                _starterChip(Icons.edit_rounded, 'Make a quiz', AppColors.apricot, AppColors.apricot2,
                    () => _send('Help me make a quiz')),
                const SizedBox(width: 10),
                _starterChip(Icons.language_rounded, 'Explain in Urdu', AppColors.indigo400, AppColors.indigo600,
                    () => _send('Help me explain in Urdu')),
              ],
            ),
          ),

        // composer
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.line),
              boxShadow: cardShadow,
            ),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Icon(Icons.camera_alt_rounded, color: AppColors.ink3, size: 21),
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: jk(14.5, weight: FontWeight.w500),
                    decoration: InputDecoration(
                      hintText: 'Ask a question…',
                      hintStyle: jk(14.5, weight: FontWeight.w500, color: AppColors.ink3),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    onSubmitted: _send,
                  ),
                ),
                Pressable(
                  onTap: () => _send(_controller.text),
                  child: Container(
                    width: 40, height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [AppColors.indigo400, AppColors.indigo600]),
                    ),
                    child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ),

        // extra space so composer sits above the floating tab-bar
        SizedBox(height: 120 + bottomPadding),
      ],
    );
  }

  Widget _buildOrb() {
    return Center(
      child: FloatY(
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              width: 120, height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.indigo400.withOpacity(0.18),
                boxShadow: [BoxShadow(color: AppColors.indigo400.withOpacity(0.3), blurRadius: 20)],
              ),
            ),
            const Orb(size: 92, color: AppColors.indigo400, shadow: Color(0x80454DD4),
                child: Icon(Icons.auto_awesome, size: 42, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildMsg(_ChatMsg m) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: m.isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: m.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!m.isMe)
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Orb(size: 22, color: AppColors.indigo400, shadow: Color(0x66454DD4),
                        child: Icon(Icons.auto_awesome, size: 11, color: Colors.white)),
                    const SizedBox(width: 6),
                    Text('eStudy AI', style: jk(12.5, weight: FontWeight.w800, color: AppColors.ink3)),
                  ],
                ),
              ),
            Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.82),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              decoration: BoxDecoration(
                gradient: m.isMe
                    ? const LinearGradient(colors: [AppColors.indigo400, AppColors.indigo600])
                    : null,
                color: m.isMe ? null : AppColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18), topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(m.isMe ? 18 : 5),
                  bottomRight: Radius.circular(m.isMe ? 5 : 18),
                ),
                boxShadow: cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(m.text, style: jk(14, weight: FontWeight.w500, color: m.isMe ? Colors.white : AppColors.ink, height: 1.5)),
                  if (m.steps != null) ...[
                    const SizedBox(height: 10),
                    ...m.steps!.asMap().entries.map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 20, height: 20,
                            decoration: BoxDecoration(color: AppColors.indigo50, shape: BoxShape.circle),
                            child: Center(child: Text('${e.key + 1}', style: jk(11, weight: FontWeight.w800, color: AppColors.indigo600))),
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Text(e.value, style: jk(13.5, weight: FontWeight.w500, height: 1.4))),
                        ],
                      ),
                    )),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTyping() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18), topRight: Radius.circular(18),
            bottomLeft: Radius.circular(5), bottomRight: Radius.circular(18),
          ),
          boxShadow: cardShadow,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: _Dot(delay: i * 0.18),
          )),
        ),
      ),
    );
  }

  Widget _starterChip(IconData icon, String label, Color c1, Color c2, VoidCallback onTap) {
    return Expanded(
      child: AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
        onTap: onTap,
        child: Row(
          children: [
            GradientTile(icon: icon, c1: c1, c2: c2, size: 38, radius: 12, iconSize: 19),
            const SizedBox(width: 10),
            Flexible(child: Text(label, style: jk(13, weight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatefulWidget {
  final double delay;
  const _Dot({required this.delay});
  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1300))..repeat();

  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) {
        final t = (_c.value - widget.delay).clamp(0.0, 1.0);
        final y = t < 0.4 ? -5.0 * (t / 0.4) : -5.0 * (1 - (t - 0.4) / 0.6);
        final opacity = t < 0.4 ? 0.4 + 0.6 * (t / 0.4) : 0.4 + 0.6 * (1 - (t - 0.4) / 0.6);
        return Transform.translate(
          offset: Offset(0, y),
          child: Container(
            width: 8, height: 8,
            decoration: BoxDecoration(color: AppColors.indigo400.withOpacity(opacity), shape: BoxShape.circle),
          ),
        );
      },
    );
  }
}
