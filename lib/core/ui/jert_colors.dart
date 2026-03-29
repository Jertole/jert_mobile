import 'package:flutter/material.dart';

class JertColors {
  JertColors._();

  // Backgrounds
  static const Color bgDeep = Color(0xFF08111A);
  static const Color bgMid = Color(0xFF0B1622);
  static const Color bgPanel = Color(0xCC121A22);
  static const Color bgModal = Color(0xFF10161F);

  // Primary glossy blue button
  static const Color glossBlueTop = Color(0xFF8FE6FF);
  static const Color glossBlueBottom = Color(0xFF34D3FF);
  static const Color glossBlueGlow = Color(0xFF34D3FF);

  // JERT neon accents
  static const Color neonCyan = Color(0xFF2CF6FF);
  static const Color neonCyanSoft = Color(0xFF7CF8FF);

  // Asset / terminal accents
  static const Color cold = Color(0xFF2CF6FF);
  static const Color lcng = Color(0xFFFFB347);
  static const Color dc = Color(0xFFB388FF);

  // Text
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color textMuted = Colors.white54;
  static const Color textDark = Colors.black87;

  // Borders
  static const Color borderSoft = Color(0x26FFFFFF);
  static const Color borderCyan = Color(0x552CF6FF);

  static LinearGradient screenOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.black.withValues(alpha: 0.30),
      const Color(0xFF060A10).withValues(alpha: 0.78),
      const Color(0xFF08111A).withValues(alpha: 0.92),
    ],
  );

  static RadialGradient neonAura = RadialGradient(
    center: const Alignment(0, -0.75),
    radius: 1.15,
    colors: [
      neonCyan.withValues(alpha: 0.10),
      Colors.transparent,
    ],
  );

  static LinearGradient primaryGlossGradient = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      glossBlueTop,
      glossBlueBottom,
    ],
  );

  static List<BoxShadow> primaryGlow = [
    BoxShadow(
      color: glossBlueGlow.withValues(alpha: 0.45),
      blurRadius: 16,
      spreadRadius: 1,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> cyanSoftGlow = [
    BoxShadow(
      color: neonCyan.withValues(alpha: 0.16),
      blurRadius: 20,
      spreadRadius: 1,
    ),
  ];
}
