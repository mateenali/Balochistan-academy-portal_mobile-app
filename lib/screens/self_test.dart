import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets.dart';

class SelfTestScreen extends StatefulWidget {
  const SelfTestScreen({super.key});

  @override
  State<SelfTestScreen> createState() => _SelfTestScreenState();
}

class _SelfTestScreenState extends State<SelfTestScreen> {
  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> subjects = [
    {
      'name': 'Urdu',
      'urdu': 'اردو',
      'icon': Icons.menu_book_rounded,
      'bgColors': [Color(0xFFF3E8FF), Color(0xFFD8B4FE)],
      'iconColor': Color(0xFF6D28D9),
    },
    {
      'name': 'Mutalia Pakistan',
      'urdu': 'مطالعہ پاکستان',
      'icon': Icons.public_rounded,
      'bgColors': [Color(0xFFD1FAE5), Color(0xFF34D399)],
      'iconColor': Color(0xFF065F46),
    },
    {
      'name': 'English',
      'urdu': 'انگریزی',
      'icon': Icons.edit_rounded,
      'bgColors': [Color(0xFFFFF7ED), Color(0xFFFDBA74)],
      'iconColor': Color(0xFFC2410C),
    },
    {
      'name': 'Biology',
      'urdu': 'حیاتیات',
      'icon': Icons.biotech_rounded,
      'bgColors': [Color(0xFFFFF0F6), Color(0xFFFFADD2)],
      'iconColor': Color(0xFF9D174D),
    },
    {
      'name': 'Chemistry',
      'urdu': 'کیمیاء',
      'icon': Icons.travel_explore_rounded,
      'bgColors': [Color(0xFFFFF1F2), Color(0xFFFDA4AF)],
      'iconColor': Color(0xFF9F1239),
    },
    {
      'name': 'Physics',
      'urdu': 'طبیعیات',
      'icon': Icons.bolt_rounded,
      'bgColors': [Color(0xFFFFFBEB), Color(0xFFFCD34D)],
      'iconColor': Color(0xFF92400E),
    },
    {
      'name': 'Mathematics',
      'urdu': 'ریاضی',
      'icon': Icons.straighten_rounded,
      'bgColors': [Color(0xFFEFF6FF), Color(0xFF93C5FD)],
      'iconColor': Color(0xFF1E3A8A),
    },
    {
      'name': 'Pakistan Studies',
      'urdu': 'پاکستان سٹڈیز',
      'icon': Icons.account_balance_rounded,
      'bgColors': [Color(0xFFFDF4FF), Color(0xFFE879F9)],
      'iconColor': Color(0xFF701A75),
    },
    {
      'name': 'Islamiyat Lazmi',
      'urdu': 'اسلامیات لازمی',
      'icon': Icons.mosque_rounded,
      'bgColors': [Color(0xFFF0FDFA), Color(0xFF5EEAD4)],
      'iconColor': Color(0xFF134E4A),
    },
    {
      'name': 'Computer Science',
      'urdu': 'کمپیوٹر سائنس',
      'icon': Icons.computer_rounded,
      'bgColors': [Color(0xFFE8F5E9), Color(0xFF4CAF50)],
      'iconColor': Color(0xFF1B5E20),
    },
  ];

  List<Map<String, dynamic>> get _filteredSubjects {
    if (_selectedFilter == 'All') return subjects;

    if (_selectedFilter == 'English') {
      final englishSubjects = [
        'English', 'Biology', 'Chemistry', 'Physics',
        'Mathematics', 'Pakistan Studies', 'Computer Science'
      ];
      return subjects.where((s) => englishSubjects.contains(s['name'])).toList();
    }

    if (_selectedFilter == 'Urdu') {
      final urduSubjects = ['Urdu', 'Mutalia Pakistan', 'Islamiyat Lazmi'];
      return subjects.where((s) => urduSubjects.contains(s['name'])).toList();
    }

    return subjects;
  }

  void _showTestTypeDialog(BuildContext context, Map<String, dynamic> subject) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.75),
      builder: (context) => _TestTypeDialog(subject: subject),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBg,
      body: Column(
        children: [
          // ── Gradient Header ──────────────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF6D28D9), Color(0xFFBE185D)],
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            padding: EdgeInsets.fromLTRB(
                22, MediaQuery.of(context).padding.top + 16, 22, 20),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 12),
                Text(
                  'Student Self Test',
                  style: jk(20, weight: FontWeight.w800, color: Colors.white),
                ),
              ],
            ),
          ),

          // ── Filter Buttons ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 14, 22, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _filterChip('All'),
                const SizedBox(width: 8),
                _filterChip('English'),
                const SizedBox(width: 8),
                _filterChip('Urdu'),
              ],
            ),
          ),

          // ── Subject Grid ─────────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 8, 22, 8),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.0,
                ),
                itemCount: _filteredSubjects.length,
                itemBuilder: (context, index) {
                  final subject = _filteredSubjects[index];
                  return _SubjectCard(
                    name: subject['name'],
                    urdu: subject['urdu'],
                    icon: subject['icon'],
                    bgColors: subject['bgColors'],
                    iconColor: subject['iconColor'],
                    onTap: () => _showTestTypeDialog(context, subject),
                  );
                },
              ),
            ),
          ),

          // ── Footer ────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(14),
            child: Text(
              '© 2026 Balochistan Academy Portal – AI-Powered Board Exam Preparation',
              textAlign: TextAlign.center,
              style: jk(9.5, weight: FontWeight.w500, color: AppColors.ink3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6D28D9) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF6D28D9) : Colors.grey.shade300,
            width: 1.0,
          ),
        ),
        child: Text(
          label,
          style: jk(11,
              weight: FontWeight.w700,
              color: isSelected ? Colors.white : Colors.grey.shade700),
        ),
      ),
    );
  }
}

// ── Test Type Dialog ────────────────────────────────────────────────────────

class _TestTypeDialog extends StatelessWidget {
  final Map<String, dynamic> subject;

  const _TestTypeDialog({required this.subject});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1F3A),
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'CHOOSE TEST TYPE',
                  style: jk(13,
                      weight: FontWeight.w800,
                      color: Colors.white.withOpacity(0.55)),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close_rounded,
                      color: Colors.white.withOpacity(0.55), size: 22),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _TestOption(
              icon: Icons.gps_fixed_rounded,
              iconBgColor: Colors.white.withOpacity(0.25),
              iconColor: Colors.white,
              label: 'GENERAL SELF TEST',
              gradientColors: const [Color(0xFF22C55E), Color(0xFF16A34A)],
              onTap: () {
                Navigator.pop(context);
                // TODO: navigate to general self test
              },
            ),
            const SizedBox(height: 12),
            _TestOption(
              icon: Icons.description_outlined,
              iconBgColor: Colors.white.withOpacity(0.20),
              iconColor: Colors.white,
              label: 'TEST YOURSELF IN PAST PAPER',
              gradientColors: const [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
              onTap: () {
                Navigator.pop(context);
                // TODO: navigate to past paper test
              },
            ),
            const SizedBox(height: 12),
            _TestOption(
              icon: Icons.smart_toy_rounded,
              iconBgColor: Colors.white.withOpacity(0.20),
              iconColor: Colors.white,
              label: 'TEST YOURSELF IN PREDICTED EXAM',
              gradientColors: const [Color(0xFF06B6D4), Color(0xFF0891B2)],
              onTap: () {
                Navigator.pop(context);
                // TODO: navigate to predicted exam test
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ── Single Test Option Button ───────────────────────────────────────────────

class _TestOption extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String label;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const _TestOption({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.label,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: jk(14, weight: FontWeight.w800, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Subject Card Widget ────────────────────────────────────────────────────

class _SubjectCard extends StatelessWidget {
  final String name;
  final String urdu;
  final IconData icon;
  final List<Color> bgColors;
  final Color iconColor;
  final VoidCallback onTap;

  const _SubjectCard({
    required this.name,
    required this.urdu,
    required this.icon,
    required this.bgColors,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.line.withOpacity(0.3)),
          boxShadow: cardShadow,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: bgColors,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, size: 30, color: iconColor),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: jk(13, weight: FontWeight.w700, color: AppColors.ink),
            ),
            const SizedBox(height: 2),
            Text(
              urdu,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: jk(10.5, weight: FontWeight.w500, color: AppColors.ink3),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _badge(
                  'Grade 9',
                  bgColor: const Color(0xFFDBEAFE),
                  borderColor: const Color(0xFF93C5FD),
                  textColor: const Color(0xFF1D4ED8),
                ),
                const SizedBox(width: 5),
                _badge(
                  'Balochistan',
                  bgColor: const Color(0xFFEDE9FE),
                  borderColor: const Color(0xFFC4B5FD),
                  textColor: const Color(0xFF5B21B6),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(String label,
      {required Color bgColor,
        required Color borderColor,
        required Color textColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 0.8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}