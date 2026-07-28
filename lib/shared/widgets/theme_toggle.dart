import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/theme_mode_provider.dart';

class ThemeToggle extends ConsumerWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;

    return GestureDetector(
      onTap: () {
        final current = ref.read(themeModeProvider);
        ref.read(themeModeProvider.notifier).state =
            current == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        width: 64,
        height: 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: isDark ? const Color(0xFF1A1919) : const Color(0xFFD1F2E0),
          border: Border.all(
            color: isDark
                ? const Color(0xFFA37EF9).withValues(alpha: 0.3)
                : const Color(0xFF28BD7A).withValues(alpha: 0.15),
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              top: 2,
              left: isDark ? 30 : 2,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white, Color(0xFFE3E3E3)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? const Color(0xFF7243DE).withValues(alpha: 0.6)
                          : const Color(0xFF38B25B).withValues(alpha: 0.4),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 8,
              top: 5,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: isDark ? 0 : 1,
                child: const Icon(
                  Icons.wb_sunny,
                  size: 16,
                  color: Color(0xFF28BD7A),
                ),
              ),
            ),
            Positioned(
              right: 8,
              top: 5,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: isDark ? 1 : 0,
                child: const Icon(
                  Icons.brightness_2,
                  size: 16,
                  color: Color(0xFFA480FA),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
