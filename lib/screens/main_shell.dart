import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets.dart';
import 'home.dart';
import 'subjects.dart';
import 'tutor.dart';
import 'progress.dart';
import 'profile.dart';

class MainShell extends StatefulWidget {
  final int initialIndex;
  const MainShell({super.key, this.initialIndex = 0});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int index = widget.initialIndex;

  void _go(int i) => setState(() => index = i);

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(onTab: _go),
      const SubjectsScreen(),
      const TutorScreen(),
      const ProgressScreen(),
      ProfileScreen(onTab: _go),
    ];
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: index, children: screens),
      bottomNavigationBar: _TabBar(index: index, onTap: _go),
    );
  }
}

class _TabBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;
  const _TabBar({required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewPadding.bottom;
    return Container(
      margin: EdgeInsets.fromLTRB(14, 0, 14, 14 + bottom),
      height: 66,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white),
        boxShadow: const [BoxShadow(color: Color(0x4018222E), blurRadius: 30, offset: Offset(0, 10), spreadRadius: -10)],
      ),
      child: Row(
        children: [
          Expanded(child: _item(0, Icons.home_rounded, 'Home')),
          Expanded(child: _item(1, Icons.grid_view_rounded, 'Subjects')),
          _center(),
          Expanded(child: _item(3, Icons.bar_chart_rounded, 'Progress')),
          Expanded(child: _item(4, Icons.person_rounded, 'Profile')),
        ],
      ),
    );
  }

  Widget _item(int i, IconData icon, String label) {
    final active = index == i;
    final color = active ? AppColors.teal600 : AppColors.ink3;
    return Pressable(
      onTap: () => onTap(i),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 23, color: color),
          const SizedBox(height: 3),
          Text(label, style: jk(10, weight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }

  Widget _center() {
    final active = index == 2;
    return Pressable(
      onTap: () => onTap(2),
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment(-0.6, -0.8),
            end: Alignment(0.6, 0.8),
            colors: [AppColors.indigo400, AppColors.indigo600],
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: AppColors.indigo600.withOpacity(0.65),
              blurRadius: 26,
              offset: const Offset(0, 14),
              spreadRadius: -8,
            ),
            if (active)
              BoxShadow(
                color: AppColors.indigo400.withOpacity(0.35),
                blurRadius: 32,
                offset: const Offset(0, 8),
              ),
          ],
        ),
        child: Stack(
          children: [
            // Glossy inset highlight (simulates CSS inset box-shadow)
            Positioned(
              top: 1, left: 6, right: 6,
              child: Container(
                height: 26,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.35),
                      Colors.white.withOpacity(0.0),
                    ],
                    stops: const [0, 0.7],
                  ),
                ),
              ),
            ),
            // Icon
            const Center(
              child: Icon(Icons.auto_awesome, color: Colors.white, size: 26),
            ),
          ],
        ),
      ),
    );
  }
}
