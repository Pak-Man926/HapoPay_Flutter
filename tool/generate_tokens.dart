import 'dart:convert';
import 'dart:io';

void main() async {
  final inputFile = File('src/tokens.json');
  final outputFile = File('lib/core/theme/tokens.dart');

  if (!inputFile.existsSync()) {
    stderr.writeln('Error: src/tokens.json not found');
    exit(1);
  }

  final jsonString = await inputFile.readAsString();
  final Map<String, dynamic> tokens = jsonDecode(jsonString);

  final colorTokens = tokens['color'] as Map<String, dynamic>? ?? {};

  // Extract dark theme colors
  final darkColors = <String, String>{};
  for (final entry in colorTokens.entries) {
    final key = entry.key;
    final value = entry.value;
    if (value is Map && value['value'] is String) {
      final val = value['value'] as String;
      if (val.startsWith('#')) {
        darkColors[key] = val.toUpperCase();
      }
    }
  }

  // Extract light theme colors
  final lightColors = <String, String>{};
  final lightSection = colorTokens['light'] as Map<String, dynamic>? ?? {};
  for (final entry in lightSection.entries) {
    final key = entry.key;
    final value = entry.value;
    if (value is Map && value['value'] is String) {
      final val = value['value'] as String;
      if (val.startsWith('#')) {
        lightColors[key] = val.toUpperCase();
      }
    }
  }

  // Fallback to dark colors for missing light colors
  if (!lightColors.containsKey('primary')) {
    lightColors['primary'] = darkColors['primaryVariant'] ?? '#6200EE';
  }
  if (!lightColors.containsKey('secondary')) {
    lightColors['secondary'] = darkColors['secondary'] ?? '#03DAC6';
  }
  if (!lightColors.containsKey('surface')) {
    lightColors['surface'] = '#F5F5F5';
  }
  if (!lightColors.containsKey('error')) {
    lightColors['error'] = darkColors['error'] ?? '#CF6679';
  }
  if (!lightColors.containsKey('onPrimary')) {
    lightColors['onPrimary'] = '#FFFFFF';
  }
  if (!lightColors.containsKey('onSecondary')) {
    lightColors['onSecondary'] = '#000000';
  }
  if (!lightColors.containsKey('onSurface')) {
    lightColors['onSurface'] = '#1F1F1F';
  }
  if (!lightColors.containsKey('onError')) {
    lightColors['onError'] = '#FFFFFF';
  }

  // Ensure dark has required colors
  if (!darkColors.containsKey('onPrimary')) {
    darkColors['onPrimary'] = '#000000';
  }
  if (!darkColors.containsKey('onSecondary')) {
    darkColors['onSecondary'] = '#000000';
  }
  if (!darkColors.containsKey('onSurface')) {
    darkColors['onSurface'] = '#FFFFFF';
  }
  if (!darkColors.containsKey('onError')) {
    darkColors['onError'] = '#000000';
  }

  final buffer = StringBuffer();
  buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
  buffer.writeln(
      '// Generated from src/tokens.json by tool/generate_tokens.dart');
  buffer.writeln('');
  buffer.writeln("import 'package:flutter/material.dart';");
  buffer.writeln('');
  buffer.writeln('/// Design tokens generated from src/tokens.json');
  buffer.writeln('class AppTokens {');
  buffer.writeln('  AppTokens._();');
  buffer.writeln('');

  // Dark theme ColorScheme
  buffer.writeln('  // Dark theme ColorScheme');
  buffer.writeln('  static const ColorScheme darkColorScheme = ColorScheme(');
  buffer.writeln('    brightness: Brightness.dark,');
  buffer.writeln(
      '    primary: ${_colorConst(darkColors['primary'] ?? '#BB86FC')},');
  buffer.writeln(
      '    primaryContainer: ${_colorConst(darkColors['primaryVariant'] ?? '#6200EE')},');
  buffer.writeln(
      '    secondary: ${_colorConst(darkColors['secondary'] ?? '#03DAC6')},');
  buffer.writeln(
      '    secondaryContainer: ${_colorWithAlpha(darkColors['secondary'] ?? '#03DAC6', 0x4D)},');
  buffer.writeln(
      '    surface: ${_colorConst(darkColors['surface'] ?? '#1E1E1E')},');
  buffer.writeln(
      '    surfaceContainerHighest: ${_colorConst(darkColors['surface'] ?? '#1E1E1E')},');
  buffer
      .writeln('    error: ${_colorConst(darkColors['error'] ?? '#CF6679')},');
  buffer.writeln(
      '    onPrimary: ${_colorConst(darkColors['onPrimary'] ?? '#000000')},');
  buffer.writeln(
      '    onSecondary: ${_colorConst(darkColors['onSecondary'] ?? '#000000')},');
  buffer.writeln(
      '    onSurface: ${_colorConst(darkColors['onSurface'] ?? '#FFFFFF')},');
  buffer.writeln(
      '    onError: ${_colorConst(darkColors['onError'] ?? '#000000')},');
  buffer.writeln(
      '    outline: ${_colorWithAlpha(darkColors['onSurface'] ?? '#FFFFFF', 0x59)},');
  buffer.writeln(
      '    outlineVariant: ${_colorWithAlpha(darkColors['onSurface'] ?? '#FFFFFF', 0x33)},');
  buffer.writeln('    shadow: Color(0xFF000000),');
  buffer.writeln('    scrim: Color(0xFF000000),');
  buffer.writeln(
      '    inverseSurface: ${_colorConst(lightColors['surface'] ?? '#F5F5F5')},');
  buffer.writeln(
      '    onInverseSurface: ${_colorConst(lightColors['onSurface'] ?? '#1F1F1F')},');
  buffer.writeln(
      '    inversePrimary: ${_colorConst(lightColors['primary'] ?? '#6200EE')},');
  buffer.writeln('  );');
  buffer.writeln('');

  // Light theme ColorScheme
  buffer.writeln('  // Light theme ColorScheme');
  buffer.writeln('  static const ColorScheme lightColorScheme = ColorScheme(');
  buffer.writeln('    brightness: Brightness.light,');
  buffer.writeln(
      '    primary: ${_colorConst(lightColors['primary'] ?? '#6200EE')},');
  buffer.writeln(
      '    primaryContainer: ${_colorWithAlpha(lightColors['primary'] ?? '#6200EE', 0x4D)},');
  buffer.writeln(
      '    secondary: ${_colorConst(lightColors['secondary'] ?? '#03DAC6')},');
  buffer.writeln(
      '    secondaryContainer: ${_colorWithAlpha(lightColors['secondary'] ?? '#03DAC6', 0x4D)},');
  buffer.writeln(
      '    surface: ${_colorConst(lightColors['surface'] ?? '#F5F5F5')},');
  buffer.writeln(
      '    surfaceContainerHighest: ${_colorConst(lightColors['surface'] ?? '#F5F5F5')},');
  buffer
      .writeln('    error: ${_colorConst(lightColors['error'] ?? '#B3261E')},');
  buffer.writeln(
      '    onPrimary: ${_colorConst(lightColors['onPrimary'] ?? '#FFFFFF')},');
  buffer.writeln(
      '    onSecondary: ${_colorConst(lightColors['onSecondary'] ?? '#000000')},');
  buffer.writeln(
      '    onSurface: ${_colorConst(lightColors['onSurface'] ?? '#1F1F1F')},');
  buffer.writeln(
      '    onError: ${_colorConst(lightColors['onError'] ?? '#FFFFFF')},');
  buffer.writeln(
      '    outline: ${_colorWithAlpha(lightColors['onSurface'] ?? '#1F1F1F', 0x59)},');
  buffer.writeln(
      '    outlineVariant: ${_colorWithAlpha(lightColors['onSurface'] ?? '#1F1F1F', 0x33)},');
  buffer.writeln('    shadow: Color(0xFF000000),');
  buffer.writeln('    scrim: Color(0xFF000000),');
  buffer.writeln(
      '    inverseSurface: ${_colorConst(darkColors['surface'] ?? '#1E1E1E')},');
  buffer.writeln(
      '    onInverseSurface: ${_colorConst(darkColors['onSurface'] ?? '#FFFFFF')},');
  buffer.writeln(
      '    inversePrimary: ${_colorConst(darkColors['primary'] ?? '#BB86FC')},');
  buffer.writeln('  );');
  buffer.writeln('');

  // Individual color constants for backwards compatibility
  buffer
      .writeln('  // Individual color constants (for backwards compatibility)');
  final individualColors = {
    'primary': darkColors['primary'] ?? '#BB86FC',
    'primaryVariant': darkColors['primaryVariant'] ?? '#6200EE',
    'secondary': darkColors['secondary'] ?? '#03DAC6',
    'background': darkColors['background'] ?? '#121212',
    'surface': darkColors['surface'] ?? '#1E1E1E',
    'error': darkColors['error'] ?? '#CF6679',
    'onPrimary': darkColors['onPrimary'] ?? '#000000',
    'onSecondary': darkColors['onSecondary'] ?? '#000000',
    'onSurface': darkColors['onSurface'] ?? '#FFFFFF',
    'onError': darkColors['onError'] ?? '#000000',
  };

  for (final entry in individualColors.entries) {
    buffer.writeln(
        '  static const Color ${_toCamelCase(entry.key)} = ${_colorConst(entry.value)};');
  }
  buffer.writeln('');

  // Spacing
  final spacing = tokens['spacing'] as Map<String, dynamic>? ?? {};
  if (spacing.isNotEmpty) {
    buffer.writeln('  // Spacing tokens');
    for (final entry in spacing.entries) {
      final value = entry.value['value'] as num;
      buffer.writeln(
          '  static const double ${_toCamelCase(entry.key)} = ${value.toDouble()};');
    }
    buffer.writeln('');
  }

  // Border Radius
  final borderRadius = tokens['borderRadius'] as Map<String, dynamic>? ?? {};
  if (borderRadius.isNotEmpty) {
    buffer.writeln('  // Border radius tokens');
    for (final entry in borderRadius.entries) {
      final value = entry.value['value'] as num;
      buffer.writeln(
          '  static const double radius${_toPascalCase(entry.key)} = ${value.toDouble()};');
    }
    buffer.writeln('');
  }

  // Typography
  final typography = tokens['typography'] as Map<String, dynamic>? ?? {};
  if (typography.isNotEmpty) {
    buffer.writeln('  // Typography tokens');
    for (final entry in typography.entries) {
      final key = entry.key;
      final value = entry.value['value'];

      if (key == 'fontFamily') {
        final fontFamily = value as String;
        buffer.writeln("  static const String fontFamily = '$fontFamily';");
      } else if (value is Map<String, dynamic>) {
        buffer.writeln(
            '  static const TextStyle ${_toCamelCase(key)} = TextStyle(');
        if (value['fontSize'] != null) {
          buffer.writeln('    fontSize: ${value['fontSize']}.0,');
        }
        if (value['fontWeight'] != null) {
          buffer.writeln('    fontWeight: FontWeight.w${value['fontWeight']},');
        }
        if (value['lineHeight'] != null && value['fontSize'] != null) {
          final height =
              (value['lineHeight'] as num) / (value['fontSize'] as num);
          buffer.writeln('    height: $height,');
        }
        if (value['letterSpacing'] != null) {
          buffer.writeln('    letterSpacing: ${value['letterSpacing']},');
        }
        buffer.writeln('  );');
        buffer.writeln('');
      }
    }
  }

  buffer.writeln('}');

  await outputFile.parent.create(recursive: true);
  await outputFile.writeAsString(buffer.toString());

  print('Generated ${outputFile.path}');
}

String _colorConst(String hex) {
  final clean = hex.replaceFirst('#', '').toUpperCase();
  return 'Color(0xFF$clean)';
}

String _colorWithAlpha(String hex, int alpha) {
  final clean = hex.replaceFirst('#', '').toUpperCase();
  final alphaHex = alpha.toRadixString(16).toUpperCase().padLeft(2, '0');
  return 'Color(0x$alphaHex$clean)';
}

String _toCamelCase(String s) {
  final parts = s.split(RegExp(r'[-_\s]'));
  if (parts.isEmpty) return s;
  final first = parts.first.toLowerCase();
  final rest = parts
      .skip(1)
      .map((p) => p[0].toUpperCase() + p.substring(1).toLowerCase())
      .join();
  return first + rest;
}

String _toPascalCase(String s) {
  final parts = s.split(RegExp(r'[-_\s]'));
  if (parts.isEmpty) return s;
  return parts
      .map((p) => p[0].toUpperCase() + p.substring(1).toLowerCase())
      .join();
}
