import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hapopay/core/theme/tokens.dart';

class AltAuthOption extends StatelessWidget {
  final String emoji;
  final String label;
  final Color cardColor;
  final Color borderColor;
  final Color foregroundColor;
  final VoidCallback onTap;

  const AltAuthOption({
    super.key,
    required this.emoji,
    required this.label,
    required this.cardColor,
    required this.borderColor,
    required this.foregroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: AppTokens.borderRadiusLg,
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppTokens.borderRadiusLg,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            child: Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 14),
                Text(
                  label,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: foregroundColor,
                  ),
                ),
                const Spacer(),
                Icon(Icons.chevron_right_rounded, color: borderColor, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}