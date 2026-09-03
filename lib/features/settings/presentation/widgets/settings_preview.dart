import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hapopay/core/constants/constants.dart';
import 'package:hapopay/core/theme/tokens.dart';

class ThemePreviewBox extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color previewBgColor;
  final Color accentBarColor;
  final VoidCallback onTap;

  const ThemePreviewBox({
    super.key,
    required this.label,
    required this.isSelected,
    required this.previewBgColor,
    required this.accentBarColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTokens.primary.withValues(alpha: 0.12)
              : Theme.of(context).brightness == Brightness.dark
                  ? AppTokens.darkSecondary
                  : AppTokens.lightSecondary,
          borderRadius: AppTokens.borderRadiusLg,
          border: Border.all(
            color: isSelected ? AppTokens.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 32,
              height: 20,
              decoration: BoxDecoration(
                color: previewBgColor,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.black12, width: 0.5),
              ),
              child: Center(
                child: Container(
                  width: 12,
                  height: 4,
                  decoration: BoxDecoration(
                    color: accentBarColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            const Spacing.vertical(6),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? AppTokens.primary
                    : AppTokens.lightMutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
