import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hapopay/core/theme/tokens.dart';

class QuickSpendBtn extends StatelessWidget {
  final String emoji;
  final String label;
  final Color cardColor;
  final Color borderColor;
  final Color foregroundColor;
  final Color mutedColor;
  final VoidCallback onTap;

  const QuickSpendBtn({
    super.key,
    required this.emoji,
    required this.label,
    required this.cardColor,
    required this.borderColor,
    required this.foregroundColor,
    required this.mutedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: AppTokens.borderRadiusLg,
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: mutedColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
