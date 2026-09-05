import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/storage_provider.dart';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  static const _prefKey = 'app_theme_mode';

  @override
  ThemeMode build() {
    try {
      final prefs = ref.watch(sharedPreferencesProvider);
      final savedMode = prefs.getString(_prefKey);
      if (savedMode == 'dark') return ThemeMode.dark;
      if (savedMode == 'light') return ThemeMode.light;
      if (savedMode == 'system') return ThemeMode.system;
    } catch (_) {
      // If sharedPreferences is not yet initialized or fails
    }
    return ThemeMode.system;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    try {
      final prefs = ref.read(sharedPreferencesProvider);
      await prefs.setString(_prefKey, mode.name);
    } catch (_) {}
  }

  Future<void> toggleTheme(bool isDark) async {
    await setThemeMode(isDark ? ThemeMode.light : ThemeMode.dark);
  }
}

final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);
