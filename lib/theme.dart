import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Central palette — mirrors the design tokens from the web prototype.
class AppColors {
  // surfaces
  static const appBg = Color(0xFFF4F6FB);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceSunken = Color(0xFFEEF1F7);

  // ink
  static const ink = Color(0xFF18222E);
  static const ink2 = Color(0xFF5A6675);
  static const ink3 = Color(0xFF8C97A6);
  static const line = Color(0xFFE7EBF2);

  // teal — primary / focus
  static const teal300 = Color(0xFF6FD3C2);
  static const teal400 = Color(0xFF34BBA7);
  static const teal500 = Color(0xFF14A594);
  static const teal600 = Color(0xFF0D8979);

  // indigo / periwinkle — AI
  static const indigo50 = Color(0xFFECEDFD);
  static const indigo400 = Color(0xFF7D83EF);
  static const indigo500 = Color(0xFF5A62E6);
  static const indigo600 = Color(0xFF454DD4);

  // warm
  static const apricot = Color(0xFFFFA05A);
  static const apricot2 = Color(0xFFF0742E);
  static const coral = Color(0xFFFF7E6B);
  static const gold = Color(0xFFFFC24B);

  // subject accents
  static const sky = Color(0xFF4CB8F5);
  static const sky2 = Color(0xFF1F7FD4);
  static const rose = Color(0xFFF976A6);
  static const rose2 = Color(0xFFD63F7E);
  static const violet = Color(0xFF9B6DF0);
  static const violet2 = Color(0xFF6A35CF);
  static const lime = Color(0xFF8BCE4F);
  static const lime2 = Color(0xFF4E9E2E);
  static const cyan = Color(0xFF36C2C9);
  static const cyan2 = Color(0xFF0D8389);

  // semantic
  static const success = Color(0xFF1FAA6B);
  static const successBg = Color(0xFFE3F6EC);
}

/// Soft elevation used on cards.
const cardShadow = [
  BoxShadow(color: Color(0x0D18222E), blurRadius: 8, offset: Offset(0, 2)),
  BoxShadow(color: Color(0x1F18222E), blurRadius: 28, offset: Offset(0, 12), spreadRadius: -12),
];

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.appBg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.teal500,
      primary: AppColors.teal500,
      surface: AppColors.surface,
    ),
  );
  return base.copyWith(
    textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme).apply(
      bodyColor: AppColors.ink,
      displayColor: AppColors.ink,
    ),
    splashFactory: InkRipple.splashFactory,
  );
}

/// Urdu (Nastaliq) text style helper.
TextStyle urdu({double size = 14, Color color = AppColors.ink3, FontWeight weight = FontWeight.w600}) {
  return GoogleFonts.notoNastaliqUrdu(fontSize: size, color: color, fontWeight: weight, height: 1.9);
}

/// Quick Jakarta style helper.
TextStyle jk(double size, {FontWeight weight = FontWeight.w600, Color color = AppColors.ink, double spacing = 0, double height = 1.3}) {
  return GoogleFonts.plusJakartaSans(fontSize: size, fontWeight: weight, color: color, letterSpacing: spacing, height: height);
}
