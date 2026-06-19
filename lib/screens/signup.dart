import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _fullNameCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _gradeCtrl = TextEditingController();
  final _mediumCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();

  bool _obscure = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    _gradeCtrl.dispose();
    _mediumCtrl.dispose();
    _phoneCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  void _signUp() async {
    final fullName = _fullNameCtrl.text.trim();
    final username = _usernameCtrl.text.trim();
    final password = _passwordCtrl.text;
    final grade = _gradeCtrl.text.trim();
    final medium = _mediumCtrl.text.trim();

    if (fullName.isEmpty || username.isEmpty || password.isEmpty || grade.isEmpty || medium.isEmpty) {
      setState(() => _error = 'Please fill in all required fields.');
      return;
    }

    setState(() {
      _error = null;
      _loading = true;
    });

    await Future.delayed(const Duration(milliseconds: 900));
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBg,
      body: Column(
        children: [
          // ── gradient header ────────────────────────────────────────────────
          _SignUpHeader(),
          // ── scrollable form ────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24, 28, 24, 40 + MediaQuery.of(context).padding.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Create Your Account', style: jk(22, weight: FontWeight.w800, spacing: -0.3)),
                  const SizedBox(height: 24),

                  // ── Row 1: Full Name ──────────────────────────
                  _SignUpField(
                    controller: _fullNameCtrl,
                    hint: 'Full Name',
                    icon: Icons.person_outline_rounded,
                  ),
                  const SizedBox(height: 14),

                  // ── Row 2:  ────────────────
                  Row(
                    children: [
                      Expanded(
                        child: _SignUpField(
                          controller: _usernameCtrl,
                          hint: 'Username',
                          icon: Icons.alternate_email_rounded,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SignUpField(
                          controller: _passwordCtrl,
                          hint: 'Password',
                          icon: Icons.lock_outline_rounded,
                          obscure: _obscure,
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

                  // ── Row 3: ──────────────
                  Row(
                    children: [
                      Expanded(
                        child: _SignUpField(
                          controller: _gradeCtrl,
                          hint: 'Grade / Class',
                          icon: Icons.school_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SignUpField(
                          controller: _mediumCtrl,
                          hint: 'Medium',
                          icon: Icons.language_outlined,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),


                  Row(
                    children: [
                      Expanded(
                        child: _SignUpField(
                          controller: _phoneCtrl,
                          hint: 'Phone (Optional)',
                          icon: Icons.phone_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SignUpField(
                          controller: _cityCtrl,
                          hint: 'City (Optional)',
                          icon: Icons.location_on_outlined,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),


                  if (_error != null) ...[
                    _SignUpErrorBanner(_error!),
                    const SizedBox(height: 14),
                  ],

                  const SizedBox(height: 16),

                  // Sign Up Button
                  _loading
                      ? _SignUpLoadingButton()
                      : _SignUpPrimaryButton(
                    label: '+ Create My Account',
                    onTap: _signUp,
                  ),

                  const SizedBox(height: 22),

                  // back to login row
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
              Text('eStudy', style: jk(18, weight: FontWeight.w800, color: Colors.white, spacing: -0.3)),
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
          Text('Join eStudy', style: jk(26, weight: FontWeight.w800, color: Colors.white, spacing: -0.4)),
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
  final Widget? suffix;

  const _SignUpField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
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
            // TextField with only hint (no helper text)
            Expanded(
              child: TextField(
                controller: widget.controller,
                obscureText: widget.obscure,
                style: jk(14.5, weight: FontWeight.w600),
                decoration: InputDecoration(
                  hintText: widget.hint,
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
  final VoidCallback onTap;

  const _SignUpPrimaryButton({
    required this.label,
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
        child: Text(
          label,
          style: jk(16, weight: FontWeight.w700, color: Colors.white, spacing: 0.3),
        ),
      ),
    );
  }
}