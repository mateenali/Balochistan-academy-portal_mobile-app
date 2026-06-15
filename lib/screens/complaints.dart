import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets.dart';

class _Complaint {
  final String subject;
  final String body;
  final String date;
  final String status; // Open / Resolved
  const _Complaint(this.subject, this.body, this.date, this.status);
}

/// Complaints — raise a concern and track its status.
class ComplaintsScreen extends StatefulWidget {
  const ComplaintsScreen({super.key});
  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  final _ctrl = TextEditingController();
  final List<_Complaint> _items = [
    const _Complaint('Video not loading', 'Lesson 6 video buffers and stops on mobile data.', '12 Jun 2026', 'Open'),
    const _Complaint('Wrong answer key', 'Q3 of the Algebra quiz marks the correct option as wrong.', '08 Jun 2026', 'Resolved'),
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _items.insert(0, _Complaint('New complaint', text, '15 Jun 2026', 'Open'));
      _ctrl.clear();
    });
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.success,
        content: Text('Complaint submitted', style: jk(13.5, weight: FontWeight.w700, color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: 'Complaints',
      bottom: PrimaryButton(label: 'Submit complaint', icon: Icons.send_rounded, onTap: _submit, colors: const [AppColors.coral, AppColors.rose2]),
      children: [
        AppCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: TextField(
            controller: _ctrl,
            maxLines: 4,
            minLines: 3,
            style: jk(14, weight: FontWeight.w600, height: 1.5),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Describe your issue or feedback…',
              hintStyle: jk(14, weight: FontWeight.w600, color: AppColors.ink3),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text('Your complaints', style: jk(15, weight: FontWeight.w800)),
        const SizedBox(height: 12),
        ..._items.map((c) {
          final resolved = c.status == 'Resolved';
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(c.subject, style: jk(14.5, weight: FontWeight.w800))),
                  Chip2(
                    c.status,
                    bg: resolved ? AppColors.successBg : const Color(0xFFFFEDE8),
                    fg: resolved ? AppColors.success : AppColors.rose2,
                    icon: resolved ? Icons.check_circle_rounded : Icons.schedule_rounded,
                  ),
                ]),
                const SizedBox(height: 8),
                Text(c.body, style: jk(13, weight: FontWeight.w500, color: AppColors.ink2, height: 1.5)),
                const SizedBox(height: 8),
                Text(c.date, style: jk(12, weight: FontWeight.w600, color: AppColors.ink3)),
              ]),
            ),
          );
        }),
      ],
    );
  }
}
