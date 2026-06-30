import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets.dart';
import '../Api/api_client.dart';

class _WeekBar {
  final String day;
  final double value;
  final bool today;
  const _WeekBar(this.day, this.value, {this.today = false});
}

class _Mastery {
  final String name;
  final double value;
  final Color color;
  const _Mastery(this.name, this.value, this.color);
}

class _Badge {
  final IconData icon;
  final Color c;
  final Color shadow;
  final String label;
  const _Badge(this.icon, this.c, this.shadow, this.label);
}

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  Map<String, dynamic>? _user;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    try {
      final apiClient = ApiClient();
      final user = await apiClient.getCurrentUser();
      setState(() {
        _user = user;
        _loading = false;
      });
    } catch (e) {
      print('Failed to fetch user: $e');
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final week = [
      const _WeekBar('M', 0.60), const _WeekBar('T', 0.85), const _WeekBar('W', 0.40),
      const _WeekBar('T', 0.95), const _WeekBar('F', 0.70), const _WeekBar('S', 0.30),
      const _WeekBar('S', 0.55, today: true),
    ];
    final mastery = [
      const _Mastery('Mathematics', 0.78, AppColors.indigo500),
      const _Mastery('Chemistry', 0.64, AppColors.teal500),
      const _Mastery('English', 0.52, AppColors.apricot2),
      const _Mastery('Physics', 0.41, AppColors.sky2),
    ];
    final badges = [
      _Badge(Icons.local_fire_department, AppColors.apricot, const Color(0x80FF7828), '7-day streak'),
      _Badge(Icons.track_changes, AppColors.teal400, const Color(0x800D8979), 'Quiz master'),
      _Badge(Icons.emoji_events, AppColors.gold, const Color(0x80FFB428), 'Top 10%'),
      _Badge(Icons.bolt, AppColors.indigo400, const Color(0x80454DD4), 'Fast learner'),
    ];

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: EdgeInsets.only(bottom: 100 + MediaQuery.of(context).viewPadding.bottom),
        children: [
          // header
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 8, 22, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('YOUR PROGRESS', style: jk(11.5, weight: FontWeight.w700, color: AppColors.ink3, spacing: 1.4)),
                const SizedBox(height: 6),
                Text(
                  'Keep it up, ${_user?['name'] ?? 'User'}!',
                  style: jk(27, weight: FontWeight.w800, spacing: -0.5),
                ),
              ],
            ),
          ),

          // hero coins card
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 16, 22, 0),
            child: AppCard(
              clip: true,
              padding: EdgeInsets.zero,
              gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.gold, AppColors.apricot2]),
              child: Stack(
                children: [
                  Positioned(right: -20, bottom: -30, child: Container(width: 130, height: 130, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.10)))),
                  // faint giant coin behind
                  Positioned(right: -16, top: -18, child: Icon(Icons.monetization_on_rounded, size: 120, color: Colors.white.withOpacity(0.10))),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('TOTAL COINS', style: jk(12, weight: FontWeight.w700, color: Colors.white70, spacing: 0.5)),
                                const SizedBox(height: 2),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.paid_rounded, color: Colors.white, size: 30),
                                    const SizedBox(width: 8),
                                    Text('2,480', style: jk(40, weight: FontWeight.w800, color: Colors.white, spacing: -1)),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.20), borderRadius: BorderRadius.circular(999)),
                                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                                    const Icon(Icons.trending_up_rounded, color: Colors.white, size: 13),
                                    const SizedBox(width: 5),
                                    Text('+120 earned today', style: jk(12.5, weight: FontWeight.w700, color: Colors.white)),
                                  ]),
                                ),
                              ],
                            ),
                            // FloatY(
                            //   distance: 8,
                            //   child: const Orb(
                            //     size: 84,
                            //     color: AppColors.gold,
                            //     shadow: Color(0x80F0742E),
                            //     child: Icon(Icons.monetization_on_rounded, color: Colors.white, size: 42),
                            //   ),
                            // ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Pressable(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(14)),
                            child: Row(
                              children: [
                                const Icon(Icons.card_giftcard_rounded, color: Colors.white, size: 18),
                                const SizedBox(width: 10),
                                Text('Redeem rewards', style: jk(13.5, weight: FontWeight.w800, color: Colors.white)),
                                const Spacer(),
                                Text('Store', style: jk(12.5, weight: FontWeight.w700, color: Colors.white70)),
                                const SizedBox(width: 4),
                                const Icon(Icons.chevron_right_rounded, color: Colors.white, size: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // mini stats
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
            child: Row(
              children: [
                _miniStat(Icons.access_time_rounded, '34h', 'Studied', AppColors.indigo400, AppColors.indigo600),
                const SizedBox(width: 11),
                _miniStat(Icons.check_circle_outline_rounded, '156', 'Lessons', AppColors.teal400, AppColors.teal600),
                const SizedBox(width: 11),
                _miniStat(Icons.emoji_events_outlined, '12', 'Badges', AppColors.apricot, AppColors.apricot2),
              ],
            ),
          ),

          // weekly activity
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
            child: AppCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('This week', style: jk(17, weight: FontWeight.w700, spacing: -0.2)),
                      Text('+18% vs last', style: jk(12.5, weight: FontWeight.w700, color: AppColors.teal600)),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 120,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: week.map((b) {
                        return Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 600),
                                width: 26,
                                height: b.value * 95,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  gradient: b.today
                                      ? const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.apricot, AppColors.apricot2])
                                      : const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.teal300, AppColors.teal500]),
                                  boxShadow: b.today ? [BoxShadow(color: AppColors.apricot2.withOpacity(0.5), blurRadius: 14, offset: const Offset(0, 6), spreadRadius: -4)] : null,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(b.day, style: jk(12.5, weight: FontWeight.w800, color: b.today ? AppColors.apricot : AppColors.ink3)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // mastery
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 0),
            child: Text('Subject mastery', style: jk(17, weight: FontWeight.w700, spacing: -0.2)),
          ),
          const SizedBox(height: 12),
          ...mastery.asMap().entries.map((e) => Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 12),
            child: AppCard(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(e.value.name, style: jk(14, weight: FontWeight.w700)),
                      Text('${(e.value.value * 100).toInt()}%', style: jk(12.5, weight: FontWeight.w800, color: e.value.color)),
                    ],
                  ),
                  const SizedBox(height: 9),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: LinearProgressIndicator(
                      value: e.value.value,
                      minHeight: 8,
                      backgroundColor: AppColors.surfaceSunken,
                      valueColor: AlwaysStoppedAnimation(e.value.color),
                    ),
                  ),
                ],
              ),
            ),
          )),

          // badges
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 0),
            child: Text('Recent badges', style: jk(17, weight: FontWeight.w700, spacing: -0.2)),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 22),
              itemCount: badges.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (_, i) {
                final b = badges[i];
                return SizedBox(
                  width: 74,
                  child: Column(
                    children: [
                      FloatY(
                        distance: 8,
                        duration: const Duration(seconds: 4),
                        child: Orb(size: 62, color: b.c, shadow: b.shadow, child: Icon(b.icon, color: Colors.white, size: 28)),
                      ),
                      const SizedBox(height: 8),
                      Text(b.label, style: jk(11, weight: FontWeight.w700, color: AppColors.ink2), textAlign: TextAlign.center),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _miniStat(IconData icon, String value, String label, Color c1, Color c2) {
    return Expanded(
      child: AppCard(
        padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientTile(icon: icon, c1: c1, c2: c2, size: 34, radius: 11, iconSize: 17),
            const SizedBox(height: 9),
            Text(value, style: jk(19, weight: FontWeight.w800)),
            Text(label, style: jk(12.5, weight: FontWeight.w600, color: AppColors.ink3)),
          ],
        ),
      ),
    );
  }
}