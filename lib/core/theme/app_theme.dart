import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tokens.dart';

class AppTheme {
  // ---------------------------------------------------------------------------
  // Dark Theme
  // ---------------------------------------------------------------------------

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: AppTokens.darkColorScheme,
    scaffoldBackgroundColor: AppTokens.darkBackground,
    textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      scrolledUnderElevation: 0,
      titleTextStyle: GoogleFonts.outfit(
        color: AppTokens.darkForeground,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      iconTheme: const IconThemeData(color: AppTokens.darkForeground),
    ),
    cardTheme: CardThemeData(
      color: AppTokens.darkCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppTokens.borderRadiusXl,
        side: const BorderSide(color: AppTokens.darkBorder, width: 1),
      ),
      margin: EdgeInsets.zero,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTokens.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(
          borderRadius: AppTokens.borderRadiusLg,
        ),
        textStyle: GoogleFonts.outfit(
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppTokens.darkForeground,
        minimumSize: const Size.fromHeight(52),
        side: const BorderSide(color: AppTokens.darkBorder, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: AppTokens.borderRadiusLg,
        ),
        textStyle: GoogleFonts.outfit(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppTokens.primary,
        textStyle: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppTokens.darkCard,
      hintStyle: GoogleFonts.outfit(
        color: AppTokens.darkMutedForeground.withValues(alpha: 0.6),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      labelStyle: GoogleFonts.outfit(
        color: AppTokens.darkMutedForeground,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      border: OutlineInputBorder(
        borderRadius: AppTokens.borderRadiusLg,
        borderSide: const BorderSide(color: AppTokens.darkBorder, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppTokens.borderRadiusLg,
        borderSide: const BorderSide(color: AppTokens.darkBorder, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppTokens.borderRadiusLg,
        borderSide: const BorderSide(color: AppTokens.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppTokens.borderRadiusLg,
        borderSide: const BorderSide(color: AppTokens.warning, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppTokens.borderRadiusLg,
        borderSide: const BorderSide(color: AppTokens.warning, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    dividerTheme: const DividerThemeData(
      color: AppTokens.darkBorder,
      thickness: 1,
    ),
  );

  /// Backwards compatibility alias
  static ThemeData get darkTheme => dark;

  // ---------------------------------------------------------------------------
  // Light Theme
  // ---------------------------------------------------------------------------

  static final ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: AppTokens.lightColorScheme,
    scaffoldBackgroundColor: AppTokens.lightBackground,
    textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      scrolledUnderElevation: 0,
      titleTextStyle: GoogleFonts.outfit(
        color: AppTokens.lightForeground,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      iconTheme: const IconThemeData(color: AppTokens.lightForeground),
    ),
    cardTheme: CardThemeData(
      color: AppTokens.lightCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppTokens.borderRadiusXl,
        side: const BorderSide(color: AppTokens.lightBorder, width: 1),
      ),
      margin: EdgeInsets.zero,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTokens.primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(
          borderRadius: AppTokens.borderRadiusLg,
        ),
        textStyle: GoogleFonts.outfit(
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppTokens.lightForeground,
        minimumSize: const Size.fromHeight(52),
        side: const BorderSide(color: AppTokens.lightBorder, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: AppTokens.borderRadiusLg,
        ),
        textStyle: GoogleFonts.outfit(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppTokens.primaryDark,
        textStyle: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppTokens.lightCard,
      hintStyle: GoogleFonts.outfit(
        color: AppTokens.lightMutedForeground.withValues(alpha: 0.6),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      labelStyle: GoogleFonts.outfit(
        color: AppTokens.lightMutedForeground,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      border: OutlineInputBorder(
        borderRadius: AppTokens.borderRadiusLg,
        borderSide: const BorderSide(color: AppTokens.lightBorder, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppTokens.borderRadiusLg,
        borderSide: const BorderSide(color: AppTokens.lightBorder, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppTokens.borderRadiusLg,
        borderSide: const BorderSide(color: AppTokens.primaryDark, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppTokens.borderRadiusLg,
        borderSide: const BorderSide(color: AppTokens.warning, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppTokens.borderRadiusLg,
        borderSide: const BorderSide(color: AppTokens.warning, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    dividerTheme: const DividerThemeData(
      color: AppTokens.lightBorder,
      thickness: 1,
    ),
  );
}
