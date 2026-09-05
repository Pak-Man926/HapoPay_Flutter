import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens derived from HapoPay Figma Design System
class AppTokens {
  AppTokens._();

  // ---------------------------------------------------------------------------
  // Color Palette Constants
  // ---------------------------------------------------------------------------

  // Primary & Accent Brand Colors
  static const Color primary = Color(0xFF7C4DFF);
  static const Color primaryDark = Color(0xFF6C3AFF);
  static const Color primaryLight = Color(0xFFA78BFA);
  static const Color accent = Color(0xFF00D4A1);
  static const Color accentDark = Color(0xFF00B88A);
  static const Color accentLight = Color(0xFF5EEAD4);

  // Status & Highlights
  static const Color warning = Color(0xFFFF6B35);
  static const Color gold = Color(0xFFFFD166);
  static const Color skyBlue = Color(0xFF00B4D8);
  static const Color error = Color(0xFFFF4D4D);
  static const Color success = Color(0xFF00D4A1);

  // Dark Theme Neutral Colors
  static const Color darkBackground = Color(0xFF080B12);
  static const Color darkCard = Color(0xFF111827);
  static const Color darkSecondary = Color(0xFF1E2738);
  static const Color darkMuted = Color(0xFF1A2035);
  static const Color darkMutedForeground = Color(0xFF94A3B8);
  static const Color darkForeground = Color(0xFFF0F4FF);
  static const Color darkBorder = Color(0xFF1E2A40);

  // Light Theme Neutral Colors
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightSecondary = Color(0xFFF1F5F9);
  static const Color lightMuted = Color(0xFFE2E8F0);
  static const Color lightMutedForeground = Color(0xFF64748B);
  static const Color lightForeground = Color(0xFF0D1117);
  static const Color lightBorder = Color(0xFFE2E8F0);

  // ---------------------------------------------------------------------------
  // Gradients
  // ---------------------------------------------------------------------------

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C3AFF), Color(0xFF7C4DFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF00D4A1), Color(0xFF00B88A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF6C3AFF), Color(0xFF7C4DFF), Color(0xFF00D4A1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkHeroGradient = LinearGradient(
    colors: [Color(0xFF080B12), Color(0xFF1A0A3D), Color(0xFF0A2A1F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGlowGradient = LinearGradient(
    colors: [Color(0x337C4DFF), Color(0x1100D4A1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ---------------------------------------------------------------------------
  // ColorSchemes
  // ---------------------------------------------------------------------------

  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: primary,
    onPrimary: Colors.white,
    primaryContainer: primaryDark,
    onPrimaryContainer: Colors.white,
    secondary: accent,
    onSecondary: darkBackground,
    secondaryContainer: Color(0x3300D4A1),
    onSecondaryContainer: accent,
    surface: darkCard,
    onSurface: darkForeground,
    surfaceContainerHighest: darkSecondary,
    error: warning,
    onError: Colors.white,
    outline: darkBorder,
    outlineVariant: Color(0x331E2A40),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: lightCard,
    onInverseSurface: lightForeground,
    inversePrimary: primaryDark,
  );

  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primaryDark,
    onPrimary: Colors.white,
    primaryContainer: Color(0x226C3AFF),
    onPrimaryContainer: primaryDark,
    secondary: accent,
    onSecondary: lightForeground,
    secondaryContainer: Color(0x2200D4A1),
    onSecondaryContainer: darkBackground,
    surface: lightCard,
    onSurface: lightForeground,
    surfaceContainerHighest: lightSecondary,
    error: warning,
    onError: Colors.white,
    outline: lightBorder,
    outlineVariant: Color(0x33E2E8F0),
    shadow: Color(0x0F000000),
    scrim: Colors.black,
    inverseSurface: darkCard,
    onInverseSurface: darkForeground,
    inversePrimary: primary,
  );

  // ---------------------------------------------------------------------------
  // Spacing
  // ---------------------------------------------------------------------------
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // ---------------------------------------------------------------------------
  // Border Radii
  // ---------------------------------------------------------------------------
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radius3xl = 32.0;
  static const double radiusFull = 999.0;

  static final BorderRadius borderRadiusSm = BorderRadius.circular(radiusSm);
  static final BorderRadius borderRadiusMd = BorderRadius.circular(radiusMd);
  static final BorderRadius borderRadiusLg = BorderRadius.circular(radiusLg);
  static final BorderRadius borderRadiusXl = BorderRadius.circular(radiusXl);
  static final BorderRadius borderRadius3xl = BorderRadius.circular(radius3xl);
  static final BorderRadius borderRadiusFull =
      BorderRadius.circular(radiusFull);

  // ---------------------------------------------------------------------------
  // Typography Helpers (Outfit & DM Mono)
  // ---------------------------------------------------------------------------
  static TextStyle outfit({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.outfit(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle mono({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.dmMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }
}
