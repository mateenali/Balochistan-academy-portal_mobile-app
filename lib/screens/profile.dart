import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets.dart';
import 'login.dart';
import '../Api/api_client.dart';

class _MenuRow {
  final IconData icon;
  final Color c1, c2;
  final String label, meta;
  const _MenuRow(this.icon, this.c1, this.c2, this.label, this.meta);
}

class ProfileScreen extends StatefulWidget {
  final ValueChanged<int> onTab;
  const ProfileScreen({super.key, required this.onTab});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // bool _langEn = true; // language option disabled
  bool _reminders = true;


  Map<String, dynamic>? _user;
  bool _loading = true;

  final _rows = [
    _MenuRow(Icons.track_changes, AppColors.indigo400, AppColors.indigo600, 'My goals', 'FSc Pre-Medical'),
    _MenuRow(Icons.calendar_today_rounded, AppColors.teal400, AppColors.teal600, 'Study schedule', 'Daily · 6:00 PM'),
    _MenuRow(Icons.emoji_events_outlined, AppColors.apricot, AppColors.apricot2, 'Achievements', '12 badges'),
    _MenuRow(Icons.picture_as_pdf_rounded, AppColors.rose, AppColors.rose2, 'Downloads', 'Offline lessons'),
  ];


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
      print(' Failed to fetch user: $e');
      setState(() => _loading = false);
    }
  }

  Future<void> _logout() async {
    try {
      final apiClient = ApiClient();
      await apiClient.logout();
      print('Logout successful');

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } catch (e) {
      print(' Logout error: $e');
      await TokenManager.clearTokens();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: EdgeInsets.only(bottom: 130 + MediaQuery.of(context).viewPadding.bottom),
        children: [
          // header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(22, 16, 22, 64),
            decoration: const BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.indigo500, AppColors.teal500]),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Profile', style: jk(18, weight: FontWeight.w800, color: Colors.white)),
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(14)),
                      child: const Icon(Icons.settings_rounded, color: Colors.white, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Container(
                      width: 78, height: 78,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFFFD9B8), AppColors.apricot]),
                        border: Border.all(color: Colors.white.withOpacity(0.4), width: 3),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 30, offset: const Offset(0, 16), spreadRadius: -10)],
                      ),
                      child: Center(

                        child: Text(
                          _user?['name'] != null && _user!['name'].toString().isNotEmpty
                              ? _user!['name'].toString().split(' ').map((e) => e[0]).join('').toUpperCase()
                              : 'U',
                          style: jk(30, weight: FontWeight.w800, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(_user?['name'] ?? 'User', style: jk(22, weight: FontWeight.w800, color: Colors.white)),

                          Text(
                            '${_user?['gradeCode'] ?? ''} · ${_user?['board'] ?? ''}',
                            style: jk(13.5, weight: FontWeight.w600, color: Colors.white70),
                          ),
                          const SizedBox(height: 7),
                          Row(
                            children: [
                              _badge('⭐ Level 7'),
                              const SizedBox(width: 6),
                              _badge('🔥 7-day'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // stat strip
          Transform.translate(
            offset: const Offset(0, -40),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: AppCard(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Row(
                  children: [
                    _statCol('2,480', 'Coins'),
                    _divider(),
                    _statCol('156', 'Lessons'),
                    _divider(),
                    _statCol('12', 'Badges'),
                  ],
                ),
              ),
            ),
          ),

          // language
          /*
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 12),
            child: AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  const GradientTile(icon: Icons.language_rounded, c1: AppColors.violet, c2: AppColors.violet2, size: 38, radius: 12, iconSize: 19),
                  const SizedBox(width: 12),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Language', style: jk(14.5, weight: FontWeight.w700)),
                      Text('English & Urdu', style: jk(12.5, weight: FontWeight.w600, color: AppColors.ink3)),
                    ],
                  )),
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(color: AppColors.surfaceSunken, borderRadius: BorderRadius.circular(999)),
                    child: Row(
                      children: [
                        _langBtn('EN', true),
                        _langBtn('اردو', false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          */

          // reminders
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 12),
            child: AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  const GradientTile(icon: Icons.notifications_none_rounded, c1: AppColors.apricot, c2: AppColors.apricot2, size: 38, radius: 12, iconSize: 19),
                  const SizedBox(width: 12),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Study reminders', style: jk(14.5, weight: FontWeight.w700)),
                      Text('Daily nudge at 6:00 PM', style: jk(12.5, weight: FontWeight.w600, color: AppColors.ink3)),
                    ],
                  )),
                  Pressable(
                    onTap: () => setState(() => _reminders = !_reminders),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 48, height: 28,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: _reminders ? AppColors.teal500 : AppColors.line,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: AnimatedAlign(
                        duration: const Duration(milliseconds: 200),
                        alignment: _reminders ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          width: 22, height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 3)],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // menu rows
          ..._rows.map((r) => Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 12),
            child: AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              child: Row(
                children: [
                  GradientTile(icon: r.icon, c1: r.c1, c2: r.c2, size: 38, radius: 12, iconSize: 19),
                  const SizedBox(width: 12),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(r.label, style: jk(14.5, weight: FontWeight.w700)),
                      Text(r.meta, style: jk(12.5, weight: FontWeight.w600, color: AppColors.ink3)),
                    ],
                  )),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.ink3, size: 18),
                ],
              ),
            ),
          )),

          // logout
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 6, 22, 0),
            child: Pressable(
              onTap: _logout,
              child: Container(
                height: 54,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFFBDCD8)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout_rounded, color: AppColors.coral, size: 18),
                    const SizedBox(width: 9),
                    Text('Log out', style: jk(16, weight: FontWeight.w700, color: AppColors.coral)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('eStudy v1.0 · Made for Balochistan 🇵🇰', style: jk(12.5, weight: FontWeight.w600, color: AppColors.ink3), textAlign: TextAlign.center),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(999)),
      child: Text(text, style: jk(11.5, weight: FontWeight.w800, color: Colors.white)),
    );
  }

  Widget _statCol(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: jk(19, weight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(label, style: jk(12.5, weight: FontWeight.w600, color: AppColors.ink3)),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(width: 1, height: 30, color: AppColors.line);
  }

  /*
  Widget _langBtn(String text, bool isEn) {
    final active = _langEn == isEn;
    return Pressable(
      onTap: () => setState(() => _langEn = isEn),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: active ? AppColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          boxShadow: active ? cardShadow : null,
        ),
        child: Text(text, style: jk(13, weight: FontWeight.w800, color: active ? AppColors.teal600 : AppColors.ink3)),
      ),
    );
  }
  */
}