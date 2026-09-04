import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/theme_mode_provider.dart';
import '../../core/theme/tokens.dart';

class ThemeToggle extends ConsumerWidget {
  final double size;

  const ThemeToggle({
    super.key,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            Theme.of(context).brightness == Brightness.dark);

    final secondaryBg =
        isDark ? AppTokens.darkSecondary : AppTokens.lightSecondary;
    final mutedForeground =
        isDark ? AppTokens.darkMutedForeground : AppTokens.lightMutedForeground;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: secondaryBg,
        shape: BoxShape.circle,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            ref.read(themeModeProvider.notifier).toggleTheme(isDark);
          },
          child: Center(
            child: Icon(
              isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
              size: size * 0.48,
              color: mutedForeground,
            ),
          ),
        ),
      ),
    );
  }
}
