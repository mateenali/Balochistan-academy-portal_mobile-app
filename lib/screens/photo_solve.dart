import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets.dart';

enum _Stage { camera, scanning, result }

class PhotoSolveScreen extends StatefulWidget {
  const PhotoSolveScreen({super.key});
  @override
  State<PhotoSolveScreen> createState() => _PhotoSolveScreenState();
}

class _PhotoSolveScreenState extends State<PhotoSolveScreen> {
  _Stage _stage = _Stage.camera;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_stage == _Stage.scanning) {
      Future.delayed(const Duration(milliseconds: 2200), () {
        if (mounted) setState(() => _stage = _Stage.result);
      });
    }
  }

  void _capture() {
    if (_stage == _Stage.camera) {
      setState(() => _stage = _Stage.scanning);
      Future.delayed(const Duration(milliseconds: 2200), () {
        if (mounted) setState(() => _stage = _Stage.result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_stage == _Stage.result) return _buildResult();
    return _buildCamera();
  }

  // ─── Camera / Scanning view ───
  Widget _buildCamera() {
    return Scaffold(
      backgroundColor: const Color(0xFF0C1118),
      body: Stack(
        children: [
          // faux camera background
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(center: Alignment(0, -0.2), radius: 1.2, colors: [Color(0xFF2A3344), Color(0xFF0C1118)]),
            ),
          ),
          // scan lines
          Positioned.fill(
            child: Opacity(
              opacity: 0.04,
              child: Image.asset(
                '',
                errorBuilder: (_, __, ___) => Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(''), // no-op, we use repeating gradient instead
                    ),
                  ),
                ),
              ),
            ),
          ),
          // repeating line pattern
          Positioned.fill(
            child: CustomPaint(painter: _ScanLinesPainter()),
          ),

          // the problem on "paper"
          Center(
            child: Transform.rotate(
              angle: -0.035,
              child: Container(
                width: 240,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F1E8),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 50, offset: const Offset(0, 20))],
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('x² − 5x + 6 = 0', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22, color: Color(0xFF222222), letterSpacing: 0.5)),
                    SizedBox(height: 14),
                    Divider(color: Color(0x15000000)),
                    SizedBox(height: 14),
                    Text('Solve for x', style: TextStyle(fontSize: 12, color: Color(0xFF999999))),
                  ],
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
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
              ),
            ),
          ),

          // scanning line
          if (_stage == _Stage.scanning)
            Positioned.fill(
              child: Align(
                alignment: const Alignment(0, 0),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: -0.16, end: 0.16),
                  duration: const Duration(milliseconds: 1100),
                  curve: Curves.easeInOut,
                  onEnd: () {},
                  builder: (context, v, _) {
                    return FractionallySizedBox(
                      widthFactor: 0.8,
                      child: Align(
                        alignment: Alignment(0, v),
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Colors.transparent, AppColors.teal400, Colors.transparent]),
                            boxShadow: [BoxShadow(color: AppColors.teal400.withOpacity(0.5), blurRadius: 16, spreadRadius: 3)],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

          // corner brackets
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.46,
              child: Stack(
                children: [
                  Positioned(top: -2, left: -2, child: _corner(true, true)),
                  Positioned(top: -2, right: -2, child: _corner(true, false)),
                  Positioned(bottom: -2, left: -2, child: _corner(false, true)),
                  Positioned(bottom: -2, right: -2, child: _corner(false, false)),
                ],
              ),
            ),
          ),

          // status text
          Positioned(
            bottom: 170, left: 0, right: 0,
            child: _stage == _Stage.scanning
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.auto_awesome, color: AppColors.teal400, size: 18),
                      const SizedBox(width: 6),
                      Text('Reading your problem…', style: jk(14, weight: FontWeight.w700, color: Colors.white)),
                    ],
                  )
                : Text('Point at a question, then tap to solve', style: jk(14, weight: FontWeight.w700, color: Colors.white70), textAlign: TextAlign.center),
          ),

          // shutter bar
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 18, 0, 30),
              color: const Color(0xFF0C1118),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // gallery button
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(14)),
                    child: const Icon(Icons.picture_as_pdf_rounded, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 46),
                  // shutter
                  Pressable(
                    onTap: _capture,
                    child: Container(
                      width: 74, height: 74,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20)],
                      ),
                      child: Center(
                        child: Container(
                          width: 58, height: 58,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(colors: [AppColors.teal400, AppColors.teal600]),
                          ),
                          child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 28),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 46),
                  // flash button
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(14)),
                    child: const Icon(Icons.flash_off_rounded, color: Colors.white, size: 22),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _corner(bool top, bool left) {
    return Container(
      width: 34, height: 34,
      decoration: BoxDecoration(
        border: Border(
          top: top ? const BorderSide(color: AppColors.teal400, width: 3) : BorderSide.none,
          bottom: !top ? const BorderSide(color: AppColors.teal400, width: 3) : BorderSide.none,
          left: left ? const BorderSide(color: AppColors.teal400, width: 3) : BorderSide.none,
          right: !left ? const BorderSide(color: AppColors.teal400, width: 3) : BorderSide.none,
        ),
        borderRadius: BorderRadius.only(
          topLeft: top && left ? const Radius.circular(14) : Radius.zero,
          topRight: top && !left ? const Radius.circular(14) : Radius.zero,
          bottomLeft: !top && left ? const Radius.circular(14) : Radius.zero,
          bottomRight: !top && !left ? const Radius.circular(14) : Radius.zero,
        ),
      ),
    );
  }

  // ─── Result view ───
  Widget _buildResult() {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(22, 58, 22, 24),
        children: [
          // header
          Row(
            children: [
              Pressable(
                onTap: () => setState(() => _stage = _Stage.camera),
                child: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), boxShadow: cardShadow),
                  child: const Icon(Icons.arrow_back_rounded, size: 20, color: AppColors.ink),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Solution', style: jk(17, weight: FontWeight.w700, spacing: -0.2)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // captured problem
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            color: const Color(0xFF0C1118),
            child: Column(
              children: [
                Text('x² − 5x + 6 = 0', style: jk(22, weight: FontWeight.w800, color: Colors.white, spacing: 0.5)),
                const SizedBox(height: 6),
                Text('Detected from photo', style: jk(12.5, weight: FontWeight.w600, color: Colors.white54)),
              ],
            ),
          ),

          // step header
          const SizedBox(height: 18),
          Row(
            children: [
              const Orb(size: 30, color: AppColors.indigo400, shadow: Color(0x66454DD4),
                  child: Icon(Icons.auto_awesome, size: 15, color: Colors.white)),
              const SizedBox(width: 8),
              Text('Step-by-step solution', style: jk(17, weight: FontWeight.w700, spacing: -0.2)),
            ],
          ),

          // steps
          const SizedBox(height: 16),
          _step(1, 'Factor the quadratic', "Find two numbers that multiply to 6 and add to −5: that's −2 and −3."),
          _step(2, 'Write the factors', '(x − 2)(x − 3) = 0'),
          _step(3, 'Solve each bracket', 'x − 2 = 0 → x = 2  ·  x − 3 = 0 → x = 3'),

          // answer
          const SizedBox(height: 12),
          AppCard(
            gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.bottomRight, colors: [AppColors.successBg, Color(0xFFE8F9F0)]),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  const Icon(Icons.check_circle, color: AppColors.success, size: 22),
                  const SizedBox(width: 8),
                  Text('Answer', style: jk(15, weight: FontWeight.w800)),
                ]),
                Text('x = 2 or x = 3', style: jk(17, weight: FontWeight.w800, color: AppColors.success)),
              ],
            ),
          ),

          // buttons
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Pressable(
                  onTap: () => setState(() => _stage = _Stage.camera),
                  child: Container(
                    height: 54,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.line),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.camera_alt_rounded, size: 18, color: AppColors.ink),
                        const SizedBox(width: 9),
                        Text('New photo', style: jk(16, weight: FontWeight.w700, color: AppColors.ink)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Pressable(
                  onTap: () => Navigator.of(context).pop(),
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
                        const Icon(Icons.chat_bubble_rounded, size: 18, color: Colors.white),
                        const SizedBox(width: 9),
                        Text('Ask AI', style: jk(16, weight: FontWeight.w700, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _step(int num, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 30, height: 30,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.teal400, AppColors.teal600]),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Center(child: Text('$num', style: jk(14, weight: FontWeight.w800, color: Colors.white))),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: jk(14.5, weight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(desc, style: jk(13.5, weight: FontWeight.w500, color: AppColors.ink2, height: 1.5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Simple horizontal scan lines painter.
class _ScanLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.03);
    for (double y = 0; y < size.height; y += 4) {
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, 2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
