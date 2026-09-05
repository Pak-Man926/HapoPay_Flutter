import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color foregroundColor;
  final Color mutedColor;

  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    required this.foregroundColor,
    required this.mutedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 13,
            color: mutedColor,
          ),
        ),
        Text(
          value.isEmpty ? '—' : value,
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: foregroundColor,
          ),
        ),
      ],
    );
  }
}
