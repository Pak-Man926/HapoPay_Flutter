import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hapopay/core/constants/constants.dart';
import 'package:hapopay/core/theme/tokens.dart';

class SettingsSectionContainer extends StatelessWidget {
  final String title;
  final Color cardColor;
  final Color borderColor;
  final Color mutedForeground;
  final List<Widget> children;

  const SettingsSectionContainer({
    super.key,
    required this.title,
    required this.cardColor,
    required this.borderColor,
    required this.mutedForeground,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: AppTokens.borderRadiusXl,
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: mutedForeground,
              letterSpacing: 0.5,
            ),
          ),
          const Spacing.vertical(14),
          ...children,
        ],
      ),
    );
  }
}
