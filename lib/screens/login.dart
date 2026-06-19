import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets.dart';
import 'main_shell.dart';
import 'signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _login() async {
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;
    if (email.isEmpty || pass.isEmpty) {
      setState(() => _error = 'Please fill in all fields.');
      return;
    }
    await _enter();
  }

  /// Skip credentials and jump straight into the app with a demo account.
  void _demoLogin() async {
    _emailCtrl.text = 'demo@estudy.pk';
    _passCtrl.text = 'demo1234';
    await _enter();
  }

  Future<void> _enter() async {
    setState(() {
      _error = null;
      _loading = true;
    });
    // Simulate async auth
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _loading = false);
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, a, __) => FadeTransition(opacity: a, child: const MainShell()),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBg,
      body: Column(
        children: [
          // ── gradient header ────────────────────────────────────────────────
          _Header(),
          // ── scrollable form ────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24, 28, 24, 40 + MediaQuery.of(context).padding.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Log in to your account', style: jk(21, weight: FontWeight.w800, spacing: -0.3)),
                  const SizedBox(height: 26),

                  // email / phone
                  _Field(
                    controller: _emailCtrl,
                    label: 'Email or phone number',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 14),

                  // password
                  _Field(
                    controller: _passCtrl,
                    label: 'Password',
                    icon: Icons.lock_outline_rounded,
                    obscure: _obscure,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _login(),
                    suffix: GestureDetector(
                      onTap: () => setState(() => _obscure = !_obscure),
                      child: Icon(
                        _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        size: 20,
                        color: AppColors.ink3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: Pressable(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                        child: Text('Forgot password?', style: jk(13, weight: FontWeight.w700, color: AppColors.teal500)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // error banner
                  if (_error != null) ...[
                    _ErrorBanner(_error!),
                    const SizedBox(height: 14),
                  ],

                  const SizedBox(height: 6),

                  // login button
                  _loading
                      ? _LoadingButton()
                      : PrimaryButton(
                          label: 'Log in',
                          icon: Icons.arrow_forward_rounded,
                          onTap: _login,
                        ),

                  const SizedBox(height: 12),

                  // demo login
                  GhostButton(
                    label: 'Try demo account',
                    icon: Icons.play_circle_outline_rounded,
                    color: AppColors.indigo500,
                    borderColor: AppColors.indigo50,
                    onTap: _loading ? () {} : _demoLogin,
                  ),

                  const SizedBox(height: 28),
                  _OrDivider(),
                  const SizedBox(height: 22),

                  // sign up row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?  ", style: jk(14, weight: FontWeight.w500, color: AppColors.ink2)),
                      Pressable(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SignUpScreen()),
                          );
                        },
                        child: Text('Sign up', style: jk(14, weight: FontWeight.w800, color: AppColors.indigo500)),
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

class _Header extends StatelessWidget {
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
              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
              //   decoration: BoxDecoration(
              //     color: Colors.white.withValues(alpha: 0.18),
              //     borderRadius: BorderRadius.circular(999),
              //     border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
              //   ),
              //   child: Text('Made for Balochistan', style: jk(11, weight: FontWeight.w700, color: Colors.white)),
              // ),
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
                  child: Icon(Icons.psychology_rounded, size: 50, color: AppColors.indigo500),
                ),
                const Positioned(
                  top: -6, right: -8,
                  child: Icon(Icons.auto_awesome, color: AppColors.gold, size: 22),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text('Welcome back', style: jk(26, weight: FontWeight.w800, color: Colors.white, spacing: -0.4)),
        ],
      ),
    );
  }
}

class _Field extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscure;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Widget? suffix;
  final ValueChanged<String>? onSubmitted;

  const _Field({
    required this.controller,
    required this.label,
    required this.icon,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.suffix,
    this.onSubmitted,
  });

  @override
  State<_Field> createState() => _FieldState();
}

class _FieldState extends State<_Field> {
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
        child: TextField(
          controller: widget.controller,
          obscureText: widget.obscure,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          onSubmitted: widget.onSubmitted,
          style: jk(15, weight: FontWeight.w600),
          decoration: InputDecoration(
            hintText: widget.label,
            hintStyle: jk(14.5, weight: FontWeight.w500, color: AppColors.ink3),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 14, right: 10),
              child: Icon(widget.icon, size: 20, color: _focused ? AppColors.teal500 : AppColors.ink3),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 0),
            suffixIcon: widget.suffix != null
                ? Padding(padding: const EdgeInsets.only(right: 14), child: widget.suffix)
                : null,
            suffixIconConstraints: const BoxConstraints(minWidth: 0),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 17),
          ),
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner(this.message);

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

class _LoadingButton extends StatelessWidget {
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

class _OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.line, thickness: 1.2)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text('or', style: jk(13, weight: FontWeight.w600, color: AppColors.ink3)),
        ),
        Expanded(child: Divider(color: AppColors.line, thickness: 1.2)),
      ],
    );
  }
}
