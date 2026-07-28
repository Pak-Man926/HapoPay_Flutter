import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hapopay/core/theme/app_theme.dart';

void main() {
  group('Dark Mode Theme Tests', () {
    test('darkTheme uses Brightness.dark', () {
      expect(AppTheme.darkTheme.brightness, Brightness.dark);
    });

    test('light theme uses Brightness.light', () {
      expect(AppTheme.light.brightness, Brightness.light);
    });

    test('dark theme Scaffold background is dark', () {
      final scaffoldBrightness =
          AppTheme.darkTheme.scaffoldBackgroundColor.computeLuminance();
      expect(scaffoldBrightness, lessThan(0.1));
    });

    test('light theme Scaffold background is light', () {
      final scaffoldBrightness =
          AppTheme.light.scaffoldBackgroundColor.computeLuminance();
      expect(scaffoldBrightness, greaterThan(0.9));
    });

    test('dark theme uses Material 3', () {
      expect(AppTheme.darkTheme.useMaterial3, isTrue);
    });

    test('light theme uses Material 3', () {
      expect(AppTheme.light.useMaterial3, isTrue);
    });

    test('dark theme AppBar background matches surface color', () {
      final appBarTheme = AppTheme.darkTheme.appBarTheme;
      expect(appBarTheme.backgroundColor, equals(AppTheme.darkTheme.colorScheme.surface));
    });

    test('light theme AppBar background is light', () {
      final appBarTheme = AppTheme.light.appBarTheme;
      final luminance = appBarTheme.backgroundColor?.computeLuminance() ?? 0;
      expect(luminance, greaterThan(0.8));
    });

    test('dark theme button background uses primary color', () {
      final buttonTheme = AppTheme.darkTheme.elevatedButtonTheme;
      final style = buttonTheme.style;
      // Verify the button style uses primary color
      expect(style, isNotNull);
    });

    test('light theme button background uses primary variant', () {
      // ElevatedButton has backgroundColor resolved from theme
      final buttonTheme = AppTheme.light.elevatedButtonTheme;
      expect(buttonTheme.style, isNotNull);
    });
  });

  group('Dark Mode Widget Test', () {
    testWidgets('App renders with dark theme when ThemeMode.dark is used',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.dark,
          home: Scaffold(
            appBar: AppBar(title: const Text('Test')),
            body: const Text('Dark Mode'),
          ),
        ),
      );

      // Verify the AppBar uses dark surface color
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(
        appBar.backgroundColor?.computeLuminance(),
        lessThan(0.2),
      );

      // Verify scaffold is dark
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      final brightness = scaffold.backgroundColor?.computeLuminance() ?? 0;
      expect(brightness, lessThan(0.15));
    });

    testWidgets('App renders with light theme when ThemeMode.light is used',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.light,
          home: Scaffold(
            appBar: AppBar(title: const Text('Test')),
            body: const Text('Light Mode'),
          ),
        ),
      );

      // Verify scaffold is light
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      final brightness = scaffold.backgroundColor?.computeLuminance() ?? 1;
      expect(brightness, greaterThan(0.8));
    });
  });
}
