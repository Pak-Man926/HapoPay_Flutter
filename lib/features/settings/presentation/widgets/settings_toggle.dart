import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hapopay/core/constants/constants.dart';
import 'package:hapopay/core/theme/tokens.dart';

class SettingToggleRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String desc;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color foregroundColor;
  final Color mutedForeground;

  const SettingToggleRow({
    super.key,
    required this.icon,
    required this.label,
    required this.desc,
    required this.value,
    required this.onChanged,
    required this.foregroundColor,
    required this.mutedForeground,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: mutedForeground, size: 20),
        const Spacing.horizontal(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: foregroundColor,
                ),
              ),
              Text(
                desc,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: mutedForeground,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          activeThumbColor: AppTokens.primary,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
