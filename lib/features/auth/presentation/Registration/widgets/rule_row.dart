import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hapopay/core/theme/tokens.dart';

class RuleRow extends StatelessWidget {
  final String label;
  final bool isMet;
  final bool isDark;

  const RuleRow({
    super.key,
    required this.label,
    required this.isMet,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isMet
                ? AppTokens.accent
                : (isDark ? AppTokens.darkMuted : AppTokens.lightMuted),
          ),
          child: Center(
            child: isMet
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 12)
                : null,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isMet
                ? (isDark
                    ? AppTokens.darkForeground
                    : AppTokens.lightForeground)
                : (isDark
                    ? AppTokens.darkMutedForeground
                    : AppTokens.lightMutedForeground),
          ),
        ),
      ],
    );
  }
}
