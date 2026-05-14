import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Brand
  static const Color primary = Color(0xFF2D5016);
  static const Color primaryLight = Color(0xFF4A8024);
  static const Color primarySurface = Color(0xFFEAF2E0);
  static const Color primaryBorder = Color(0xFFB8D89A);

  // Secondary / Accent
  static const Color secondary = Color(0xFF6B8F4E);
  static const Color accent = Color(0xFF8DB870);

  // Semantic Colors
  static const Color error = Color(0xFFD93025);
  static const Color errorSurface = Color(0xFFFCE8E6);
  static const Color warning = Color(0xFFE37400);
  static const Color warningSurface = Color(0xFFFEF3E2);
  static const Color success = Color(0xFF2D5016);
  static const Color successSurface = Color(0xFFEAF2E0);
  static const Color healthy = Color(0xFF2E7D32);
  static const Color healthySurface = Color(0xFFE8F5E9);

  // Neutrals / Background
  static const Color background = Color(0xFFF7F5F0);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color inputFill = Color(0xFFF2F0EB);
  static const Color divider = Color(0xFFE8E4DC);

  // Text
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF5C5C5C);
  static const Color textHint = Color(0xFFAAAAAA);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Legacy aliases (kept for existing screens)
  static const Color white = Color(0xFFFFFFFF);
  static const Color gray = textSecondary;
  static const Color lightGray = inputFill;
  static const Color charcoal = textPrimary;
  static const Color danger = error;
  static const Color healthyTag = healthy;
  static const Color warningTag = warning;
  static const Color dangerTag = error;

  // Warm Earth Tones
  static const Color beige = Color(0xFFF5F0E8);
  static const Color warmBeige = Color(0xFFEDE8DC);
  static const Color earthLight = Color(0xFFD4C9B0);

  // Scan & AI Specific
  static const Color scanFrame = Color(0xFFFFFFFF);
  static const Color scanLine = Color(0xFF4A8024);
  static const Color scanOverlay = Color(0x66000000);

  // Dark Mode
  static const Color darkBackground = Color(0xFF111814);
  static const Color darkSurface = Color(0xFF1C231A);
  static const Color darkCard = Color(0xFF242B21);
  static const Color darkTextPrimary = Color(0xFFF0EDE8);

  // Status Badge Colors
  static Color statusHealthy = const Color(0xFF2E7D32);
  static Color statusDisease = const Color(0xFFD93025);
  static Color statusWarning = const Color(0xFFE37400);

  // Gradient presets
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2D5016), Color(0xFF4A8024)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient splashGradient = LinearGradient(
    colors: [Color(0xFFF7F5F0), Color(0xFFEAF2E0)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient resultDiseaseGradient = LinearGradient(
    colors: [Color(0xFFD93025), Color(0xFFB71C1C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
