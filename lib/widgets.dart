import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'theme.dart';

/// A glossy 3D sphere with a highlight — the signature "orb".
class Orb extends StatelessWidget {
  final double size;
  final Color color;
  final Color shadow;
  final Widget? child;
  const Orb({super.key, this.size = 90, required this.color, required this.shadow, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.4, -0.5),
          radius: 0.95,
          colors: [
            Color.lerp(color, Colors.white, 0.55)!,
            color,
            Color.lerp(color, Colors.black, 0.18)!,
          ],
          stops: const [0.0, 0.55, 1.0],
        ),
        boxShadow: [
          BoxShadow(color: shadow, blurRadius: 30, offset: const Offset(0, 16), spreadRadius: -6),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // top highlight
          Positioned(
            left: size * 0.2,
            top: size * 0.13,
            child: Container(
              width: size * 0.32,
              height: size * 0.22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [Colors.white.withOpacity(0.85), Colors.white.withOpacity(0)]),
              ),
            ),
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}

/// Rounded-square gradient tile (subject / quick-action icon) with a glossy top.
class GradientTile extends StatelessWidget {
  final IconData icon;
  final Color c1;
  final Color c2;
  final double size;
  final double radius;
  final double iconSize;
  const GradientTile({super.key, required this.icon, required this.c1, required this.c2, this.size = 56, this.radius = 18, this.iconSize = 26});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [c1, c2]),
        boxShadow: [BoxShadow(color: c2.withOpacity(0.45), blurRadius: 16, offset: const Offset(0, 8), spreadRadius: -6)],
      ),
      child: Stack(
        children: [
          // gloss
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white.withOpacity(0.28), Colors.white.withOpacity(0)],
                  stops: const [0, 0.45],
                ),
              ),
            ),
          ),
          Center(child: Icon(icon, size: iconSize, color: Colors.white)),
        ],
      ),
    );
  }
}

/// Animated circular progress ring with a gradient stroke.
class ProgressRing extends StatelessWidget {
  final double size;
  final double stroke;
  final double value; // 0..100
  final List<Color> colors;
  final Color track;
  final Widget? center;
  const ProgressRing({
    super.key,
    this.size = 116,
    this.stroke = 11,
    required this.value,
    this.colors = const [AppColors.teal400, AppColors.teal600],
    this.track = const Color(0xFFE9EEF5),
    this.center,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: value.clamp(0, 100)),
        duration: const Duration(milliseconds: 1100),
        curve: Curves.easeOutCubic,
        builder: (context, v, _) {
          return CustomPaint(
            painter: _RingPainter(v, stroke, colors, track),
            child: Center(child: center),
          );
        },
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double value;
  final double stroke;
  final List<Color> colors;
  final Color track;
  _RingPainter(this.value, this.stroke, this.colors, this.track);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - stroke) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final bg = Paint()
      ..color = track
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    canvas.drawCircle(center, radius, bg);

    final sweep = (value / 100) * 2 * math.pi;
    final fg = Paint()
      ..shader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: 3 * math.pi / 2,
        colors: colors,
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = stroke;
    canvas.drawArc(rect, -math.pi / 2, sweep, false, fg);
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) => old.value != value;
}

/// Gentle up/down floating animation wrapper.
class FloatY extends StatefulWidget {
  final Widget child;
  final double distance;
  final Duration duration;
  const FloatY({super.key, required this.child, this.distance = 12, this.duration = const Duration(seconds: 5)});

  @override
  State<FloatY> createState() => _FloatYState();
}

class _FloatYState extends State<FloatY> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: widget.duration)..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final t = Curves.easeInOut.transform(_c.value);
        return Transform.translate(offset: Offset(0, -widget.distance * t), child: child);
      },
      child: widget.child,
    );
  }
}

/// White rounded card with soft shadow.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Gradient? gradient;
  final Color? color;
  final VoidCallback? onTap;
  final BoxBorder? border;
  final bool clip;
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = 24,
    this.gradient,
    this.color,
    this.onTap,
    this.border,
    this.clip = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? AppColors.surface) : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: cardShadow,
        border: border,
      ),
      clipBehavior: clip ? Clip.antiAlias : Clip.none,
      child: child,
    );
    if (onTap == null) return content;
    return _Pressable(onTap: onTap!, borderRadius: radius, child: content);
  }
}

/// Scale-down-on-press wrapper.
class _Pressable extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double borderRadius;
  const _Pressable({required this.child, required this.onTap, this.borderRadius = 18});

  @override
  State<_Pressable> createState() => _PressableState();
}

class _PressableState extends State<_Pressable> {
  double _s = 1;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _s = 0.96),
      onTapUp: (_) => setState(() => _s = 1),
      onTapCancel: () => setState(() => _s = 1),
      onTap: widget.onTap,
      child: AnimatedScale(scale: _s, duration: const Duration(milliseconds: 110), child: widget.child),
    );
  }
}

/// Public pressable wrapper (no card chrome).
class Pressable extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const Pressable({super.key, required this.child, required this.onTap});
  @override
  Widget build(BuildContext context) => _Pressable(onTap: onTap, child: child);
}

/// Standard inner-screen scaffold: back button, title, optional Urdu subtitle,
/// a scrolling body and an optional pinned bottom action.
class AppScreen extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Widget? bottom;
  const AppScreen({super.key, required this.title, required this.children, this.bottom});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 10, 22, 8),
              child: Row(
                children: [
                  Pressable(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), boxShadow: cardShadow),
                      child: const Icon(Icons.arrow_back_rounded, size: 20, color: AppColors.ink),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: jk(18, weight: FontWeight.w800, spacing: -0.3)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(22, 6, 22, 24 + MediaQuery.of(context).viewPadding.bottom),
                children: children,
              ),
            ),
            if (bottom != null)
              Padding(
                padding: EdgeInsets.fromLTRB(22, 8, 22, 16 + MediaQuery.of(context).viewPadding.bottom),
                child: bottom!,
              ),
          ],
        ),
      ),
    );
  }
}

/// Thin gradient progress bar used across report-style screens.
class ProgressBar extends StatelessWidget {
  final double value; // 0..100
  final List<Color> colors;
  final double height;
  const ProgressBar({super.key, required this.value, this.colors = const [AppColors.teal400, AppColors.teal600], this.height = 8});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        return Container(
          height: height,
          decoration: BoxDecoration(color: AppColors.surfaceSunken, borderRadius: BorderRadius.circular(999)),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: (value.clamp(0, 100)) / 100),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutCubic,
              builder: (context, v, _) => Container(
                width: c.maxWidth * v,
                height: height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: colors),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Small label chip.
class Chip2 extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;
  final IconData? icon;
  const Chip2(this.text, {super.key, this.bg = AppColors.surfaceSunken, this.fg = AppColors.ink2, this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (icon != null) ...[Icon(icon, size: 14, color: fg), const SizedBox(width: 6)],
        Text(text, style: jk(12.5, weight: FontWeight.w700, color: fg)),
      ]),
    );
  }
}

/// Primary gradient button.
class PrimaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;
  final List<Color> colors;
  const PrimaryButton({super.key, required this.label, this.icon, required this.onTap, this.colors = const [AppColors.teal500, AppColors.teal600]});
  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Container(
        height: 54,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: colors),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: colors.last.withOpacity(0.5), blurRadius: 22, offset: const Offset(0, 12), spreadRadius: -8)],
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(label, style: jk(16, weight: FontWeight.w700, color: Colors.white)),
          if (icon != null) ...[const SizedBox(width: 9), Icon(icon, size: 19, color: Colors.white)],
        ]),
      ),
    );
  }
}

/// Ghost (outline) button.
class GhostButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;
  final Color color;
  final Color borderColor;
  const GhostButton({super.key, required this.label, this.icon, required this.onTap, this.color = AppColors.ink, this.borderColor = AppColors.line});
  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Container(
        height: 54,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (icon != null) ...[Icon(icon, size: 18, color: color), const SizedBox(width: 9)],
          Text(label, style: jk(16, weight: FontWeight.w700, color: color)),
        ]),
      ),
    );
  }
}
