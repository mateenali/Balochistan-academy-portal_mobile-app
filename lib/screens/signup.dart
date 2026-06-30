import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets.dart';
import '../Api/api_client.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _fullNameCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _instituteCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  bool _obscure = true;
  bool _loading = false;
  String? _error;

  // grades loaded from the API
  List<Map<String, dynamic>> _grades = [];
  String? _selectedGrade; // selected grade code
  bool _gradesLoading = true;

  // mediums loaded from the API
  List<Map<String, dynamic>> _mediums = [];
  String? _selectedMedium; // selected medium name
  bool _mediumsLoading = true;

  final ApiClient _apiClient = ApiClient();

  @override
  void initState() {
    super.initState();
    _loadGrades();
    _loadMediums();
  }

  Future<void> _loadGrades() async {
    setState(() => _gradesLoading = true);
    try {
      final grades = await _apiClient.getGrades();
      if (!mounted) return;
      setState(() {
        _grades = grades;
        _gradesLoading = false;
      });
    } catch (e) {
      print('Load Grades Error: $e');
      if (!mounted) return;
      setState(() => _gradesLoading = false);
    }
  }

  Future<void> _loadMediums() async {
    setState(() => _mediumsLoading = true);
    try {
      final mediums = await _apiClient.getMediums();
      if (!mounted) return;
      setState(() {
        _mediums = mediums;
        _mediumsLoading = false;
      });
    } catch (e) {
      print('Load Mediums Error: $e');
      if (!mounted) return;
      setState(() => _mediumsLoading = false);
    }
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _instituteCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _signUp() async {
    final fullName = _fullNameCtrl.text.trim();
    final username = _usernameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;
    final institute = _instituteCtrl.text.trim();
    final grade = _selectedGrade;
    final medium = _selectedMedium;
    final phone = _phoneCtrl.text.trim();

    if (fullName.isEmpty || username.isEmpty || email.isEmpty || password.isEmpty || grade == null || medium == null) {
      setState(() => _error = 'Please fill in all required fields.');
      return;
    }

    final emailValid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
    if (!emailValid) {
      setState(() => _error = 'Please enter a valid email address.');
      return;
    }

    setState(() {
      _error = null;
      _loading = true;
    });

    try {

      final userData = {
        'name': fullName,
        'username': username,
        'email': email,
        'password': password,
        'institute': institute,
        'gradeCode': grade,
        'medium': medium,
        'phone': phone,
      };

      print(' Register Request: $userData');
      final response = await _apiClient.register(userData);
      print('Register Response: $response');

      if (!mounted) return;
      setState(() => _loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully! Please login.'),
          backgroundColor: AppColors.teal500,
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.of(context).pop();
    } catch (e) {
      print('Register Error: $e');
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  // Grade selector — opens a searchable, scrollable bottom sheet of grades from GET /api/grades
  Widget _gradeField() {
    Widget inner;
    if (_gradesLoading) {
      inner = Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 4),
        child: Row(
          children: [
            const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
            const SizedBox(width: 10),
            Text('Loading…', style: jk(13.5, weight: FontWeight.w600, color: AppColors.ink2)),
          ],
        ),
      );
    } else if (_grades.isEmpty) {
      inner = Pressable(
        onTap: _loadGrades,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 4),
          child: Row(
            children: [
              const Icon(Icons.refresh_rounded, size: 18, color: AppColors.coral),
              const SizedBox(width: 8),
              Text('Tap to retry', style: jk(13.5, weight: FontWeight.w600, color: AppColors.coral)),
            ],
          ),
        ),
      );
    } else {
      final selected = _selectedGrade == null
          ? null
          : _grades.firstWhere((g) => g['code'] == _selectedGrade, orElse: () => const {});
      final label = (selected != null && selected.isNotEmpty) ? selected['label'] as String : null;
      inner = InkWell(
        onTap: _pickGrade,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 4),
          child: Row(
            children: [
              Expanded(
                child: label != null
                    ? Text(label, overflow: TextOverflow.ellipsis, style: jk(14.5, weight: FontWeight.w600, color: AppColors.ink))
                    : Text.rich(TextSpan(
                        text: 'Grade / Class',
                        style: jk(13.5, weight: FontWeight.w600, color: AppColors.ink2),
                        children: [TextSpan(text: '  *', style: jk(13.5, weight: FontWeight.w800, color: AppColors.coral))],
                      )),
              ),
              const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.ink3),
              const SizedBox(width: 4),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line, width: 1.2),
        boxShadow: cardShadow,
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 14, right: 6),
            child: Icon(Icons.school_outlined, size: 20, color: AppColors.ink3),
          ),
          Expanded(child: inner),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  void _pickGrade() {
    String query = '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(sheetContext).viewInsets.bottom),
          child: StatefulBuilder(
            builder: (context, setSheetState) {
              final q = query.trim().toLowerCase();
              final filtered = q.isEmpty
                  ? _grades
                  : _grades.where((g) =>
                      (g['label'] as String).toLowerCase().contains(q) ||
                      (g['band'] as String? ?? '').toLowerCase().contains(q)).toList();
              return SizedBox(
                height: MediaQuery.of(sheetContext).size.height * 0.7,
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Container(width: 44, height: 5, decoration: BoxDecoration(color: AppColors.line, borderRadius: BorderRadius.circular(999))),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text('Select grade', style: jk(18, weight: FontWeight.w800)),
                          const Spacer(),
                          Text('${filtered.length} of ${_grades.length}', style: jk(12.5, weight: FontWeight.w600, color: AppColors.ink3)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // search box
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSunken,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            const Icon(Icons.search_rounded, size: 20, color: AppColors.ink3),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                autofocus: false,
                                style: jk(14.5, weight: FontWeight.w600),
                                onChanged: (v) => setSheetState(() => query = v),
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                  hintText: 'Search grade…',
                                  hintStyle: jk(13.5, weight: FontWeight.w600, color: AppColors.ink3),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: filtered.isEmpty
                          ? Center(child: Text('No grades found', style: jk(14, weight: FontWeight.w600, color: AppColors.ink3)))
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                              itemCount: filtered.length,
                              itemBuilder: (_, i) {
                                final g = filtered[i];
                                final code = g['code'] as String;
                                final sel = code == _selectedGrade;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Pressable(
                                    onTap: () {
                                      setState(() => _selectedGrade = code);
                                      Navigator.of(sheetContext).pop();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                                      decoration: BoxDecoration(
                                        color: sel ? AppColors.indigo50 : AppColors.surface,
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(color: sel ? AppColors.indigo400 : AppColors.line, width: sel ? 1.5 : 1),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(g['label'] as String, style: jk(15, weight: FontWeight.w800)),
                                                if (g['band'] != null)
                                                  Text(g['band'] as String, style: jk(12, weight: FontWeight.w600, color: AppColors.ink3)),
                                              ],
                                            ),
                                          ),
                                          if (sel) const Icon(Icons.check_circle_rounded, size: 20, color: AppColors.indigo500),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Medium selector — opens a searchable, scrollable bottom sheet of mediums from GET /api/mediums
  Widget _mediumField() {
    Widget inner;
    if (_mediumsLoading) {
      inner = Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 4),
        child: Row(
          children: [
            const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
            const SizedBox(width: 10),
            Text('Loading…', style: jk(13.5, weight: FontWeight.w600, color: AppColors.ink2)),
          ],
        ),
      );
    } else if (_mediums.isEmpty) {
      inner = Pressable(
        onTap: _loadMediums,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 4),
          child: Row(
            children: [
              const Icon(Icons.refresh_rounded, size: 18, color: AppColors.coral),
              const SizedBox(width: 8),
              Text('Tap to retry', style: jk(13.5, weight: FontWeight.w600, color: AppColors.coral)),
            ],
          ),
        ),
      );
    } else {
      final selected = _selectedMedium == null
          ? null
          : _mediums.firstWhere((m) => m['name'] == _selectedMedium, orElse: () => const {});
      final label = (selected != null && selected.isNotEmpty) ? selected['label'] as String : null;
      inner = InkWell(
        onTap: _pickMedium,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 4),
          child: Row(
            children: [
              Expanded(
                child: label != null
                    ? Text(label, overflow: TextOverflow.ellipsis, style: jk(14.5, weight: FontWeight.w600, color: AppColors.ink))
                    : Text.rich(TextSpan(
                        text: 'Medium',
                        style: jk(13.5, weight: FontWeight.w600, color: AppColors.ink2),
                        children: [TextSpan(text: '  *', style: jk(13.5, weight: FontWeight.w800, color: AppColors.coral))],
                      )),
              ),
              const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.ink3),
              const SizedBox(width: 4),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line, width: 1.2),
        boxShadow: cardShadow,
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 14, right: 6),
            child: Icon(Icons.language_outlined, size: 20, color: AppColors.ink3),
          ),
          Expanded(child: inner),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  void _pickMedium() {
    String query = '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(sheetContext).viewInsets.bottom),
          child: StatefulBuilder(
            builder: (context, setSheetState) {
              final q = query.trim().toLowerCase();
              final filtered = q.isEmpty
                  ? _mediums
                  : _mediums.where((m) =>
                      (m['label'] as String).toLowerCase().contains(q) ||
                      (m['name'] as String? ?? '').toLowerCase().contains(q)).toList();
              return SizedBox(
                height: MediaQuery.of(sheetContext).size.height * 0.7,
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Container(width: 44, height: 5, decoration: BoxDecoration(color: AppColors.line, borderRadius: BorderRadius.circular(999))),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text('Select medium', style: jk(18, weight: FontWeight.w800)),
                          const Spacer(),
                          Text('${filtered.length} of ${_mediums.length}', style: jk(12.5, weight: FontWeight.w600, color: AppColors.ink3)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSunken,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            const Icon(Icons.search_rounded, size: 20, color: AppColors.ink3),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                autofocus: false,
                                style: jk(14.5, weight: FontWeight.w600),
                                onChanged: (v) => setSheetState(() => query = v),
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                  hintText: 'Search medium…',
                                  hintStyle: jk(13.5, weight: FontWeight.w600, color: AppColors.ink3),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: filtered.isEmpty
                          ? Center(child: Text('No mediums found', style: jk(14, weight: FontWeight.w600, color: AppColors.ink3)))
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                              itemCount: filtered.length,
                              itemBuilder: (_, i) {
                                final m = filtered[i];
                                final name = m['name'] as String;
                                final sel = name == _selectedMedium;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Pressable(
                                    onTap: () {
                                      setState(() => _selectedMedium = name);
                                      Navigator.of(sheetContext).pop();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                                      decoration: BoxDecoration(
                                        color: sel ? AppColors.indigo50 : AppColors.surface,
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(color: sel ? AppColors.indigo400 : AppColors.line, width: sel ? 1.5 : 1),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(m['label'] as String, style: jk(15, weight: FontWeight.w800)),
                                          ),
                                          if (sel) const Icon(Icons.check_circle_rounded, size: 20, color: AppColors.indigo500),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.appBg,
      body: Column(
        children: [
          _SignUpHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24, 28, 24, 40 + MediaQuery.of(context).padding.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Create Your Account', style: jk(22, weight: FontWeight.w800, spacing: -0.3)),
                  const SizedBox(height: 24),
                  _SignUpField(
                    controller: _fullNameCtrl,
                    hint: 'Full Name',
                    icon: Icons.person_outline_rounded,
                  ),
                  const SizedBox(height: 14),
                  _SignUpField(
                    controller: _emailCtrl,
                    hint: 'Email',
                    icon: Icons.mail_outline_rounded,
                    required: true,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _SignUpField(
                          controller: _usernameCtrl,
                          hint: 'Username',
                          icon: Icons.alternate_email_rounded,
                          required: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SignUpField(
                          controller: _passwordCtrl,
                          hint: 'Password',
                          icon: Icons.lock_outline_rounded,
                          obscure: _obscure,
                          required: true,
                          suffix: GestureDetector(
                            onTap: () => setState(() => _obscure = !_obscure),
                            child: Icon(
                              _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              size: 20,
                              color: AppColors.ink3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(child: _gradeField()),
                      const SizedBox(width: 12),
                      Expanded(child: _mediumField()),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _SignUpField(
                    controller: _instituteCtrl,
                    hint: 'Institute (Optional)',
                    icon: Icons.account_balance_outlined,
                  ),
                  const SizedBox(height: 14),
                  _SignUpField(
                    controller: _phoneCtrl,
                    hint: 'Phone (Optional)',
                    icon: Icons.phone_outlined,
                  ),
                  const SizedBox(height: 10),
                  if (_error != null) ...[
                    _SignUpErrorBanner(_error!),
                    const SizedBox(height: 14),
                  ],
                  const SizedBox(height: 16),
                  _loading
                      ? _SignUpLoadingButton()
                      : _SignUpPrimaryButton(
                    label: 'Create Account',
                    icon: Icons.person_add_alt_1_rounded,
                    onTap: _signUp,
                  ),
                  const SizedBox(height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?  ", style: jk(14, weight: FontWeight.w500, color: AppColors.ink2)),
                      Pressable(
                        onTap: () => Navigator.of(context).pop(),
                        child: Text('Log in', style: jk(14, weight: FontWeight.w800, color: AppColors.indigo500)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────────────

class _SignUpHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.indigo500, AppColors.teal500],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
      ),
      padding: EdgeInsets.fromLTRB(24, MediaQuery.of(context).padding.top + 20, 24, 32),
      child: Column(
        children: [
          Row(
            children: [
              // Text('eStudy', style: jk(18, weight: FontWeight.w800, color: Colors.white, spacing: -0.3)),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 24),
          const FloatY(
            distance: 9,
            duration: Duration(seconds: 5),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Orb(
                  size: 110,
                  color: Colors.white,
                  shadow: Color(0x50454DD4),
                    child: Icon(Icons.psychology_rounded, size: 50, color: AppColors.indigo500)
                ),
                Positioned(
                  top: -6, right: -8,
                  child: Icon(Icons.auto_awesome, color: AppColors.gold, size: 22),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text('Balochistan Learning Portal', style: jk(26, weight: FontWeight.w800, color: Colors.white, spacing: -0.4)),
          const SizedBox(height: 4),
          Text('Start your learning journey today', style: jk(14, weight: FontWeight.w500, color: Colors.white70)),
        ],
      ),
    );
  }
}

class _SignUpField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final bool required;
  final Widget? suffix;

  const _SignUpField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.required = false,
    this.suffix,
  });

  @override
  State<_SignUpField> createState() => _SignUpFieldState();
}

class _SignUpFieldState extends State<_SignUpField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (v) => setState(() => _focused = v),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _focused ? AppColors.teal500 : AppColors.line,
            width: _focused ? 1.8 : 1.2,
          ),
          boxShadow: _focused
              ? [BoxShadow(color: AppColors.teal500.withOpacity(0.12), blurRadius: 10, offset: const Offset(0, 4))]
              : cardShadow,
        ),
        child: Row(
          children: [
            // Icon
            Padding(
              padding: const EdgeInsets.only(left: 14, right: 6),
              child: Icon(widget.icon, size: 20, color: _focused ? AppColors.teal500 : AppColors.ink3),
            ),

            Expanded(
              child: TextField(
                controller: widget.controller,
                obscureText: widget.obscure,
                style: jk(14.5, weight: FontWeight.w600),
                decoration: InputDecoration(
                  hint: widget.required
                      ? Text.rich(TextSpan(
                          text: widget.hint,
                          style: jk(13.5, weight: FontWeight.w600, color: AppColors.ink2),
                          children: [
                            TextSpan(text: '  *', style: jk(13.5, weight: FontWeight.w800, color: AppColors.coral)),
                          ],
                        ))
                      : null,
                  hintText: widget.required ? null : widget.hint,
                  hintStyle: jk(13.5, weight: FontWeight.w600, color: AppColors.ink2),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                ),
              ),
            ),

            if (widget.suffix != null)
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: widget.suffix,
              ),
          ],
        ),
      ),
    );
  }
}

class _SignUpErrorBanner extends StatelessWidget {
  final String message;
  const _SignUpErrorBanner(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.coral.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.coral.withOpacity(0.35)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, size: 18, color: AppColors.coral),
          const SizedBox(width: 9),
          Expanded(child: Text(message, style: jk(13.5, weight: FontWeight.w600, color: AppColors.coral))),
        ],
      ),
    );
  }
}

class _SignUpLoadingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.teal500, AppColors.teal600],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: AppColors.teal600.withOpacity(0.38), blurRadius: 22, offset: const Offset(0, 12), spreadRadius: -8)],
      ),
      child: const SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
      ),
    );
  }
}

class _SignUpPrimaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;

  const _SignUpPrimaryButton({
    required this.label,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 54,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.teal500, AppColors.teal600],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.teal600.withOpacity(0.38),
              blurRadius: 22,
              offset: const Offset(0, 12),
              spreadRadius: -8,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 19, color: Colors.white),
              const SizedBox(width: 9),
            ],
            Text(
              label,
              style: jk(16, weight: FontWeight.w700, color: Colors.white, spacing: 0.3),
            ),
          ],
        ),
      ),
    );
  }
}