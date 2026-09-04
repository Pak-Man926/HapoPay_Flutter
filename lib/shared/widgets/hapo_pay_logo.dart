import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/tokens.dart';

/// A placeholder logo widget for HapoPay matching the Figma design.
///
/// Easily replaceable by an SVG or image asset in the future.
class HapoPayLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool isHorizontal;
  final TextStyle? textStyle;
  final String? subtitle;

  const HapoPayLogo({
    super.key,
    this.size = 48,
    this.showText = false,
    this.isHorizontal = true,
    this.textStyle,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final emblem = SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _HapoPayLogoPainter(),
      ),
    );

    if (!showText) {
      return emblem;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor =
        isDark ? AppTokens.darkForeground : AppTokens.lightForeground;
    final mutedColor =
        isDark ? AppTokens.darkMutedForeground : AppTokens.lightMutedForeground;

    final textWidget = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          isHorizontal ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        if (subtitle != null && isHorizontal)
          Text(
            subtitle!,
            style: GoogleFonts.outfit(
              fontSize: (size * 0.28).clamp(11, 13),
              fontWeight: FontWeight.w500,
              color: mutedColor,
            ),
          ),
        Text(
          'HapoPay',
          style: textStyle ??
              GoogleFonts.outfit(
                fontSize: (size * 0.42).clamp(16, 28),
                fontWeight: FontWeight.w800,
                color: primaryTextColor,
                letterSpacing: -0.5,
              ),
        ),
        if (subtitle != null && !isHorizontal)
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Text(
              subtitle!,
              style: GoogleFonts.outfit(
                fontSize: (size * 0.28).clamp(12, 14),
                fontWeight: FontWeight.w400,
                color: mutedColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );

    if (isHorizontal) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          emblem,
          SizedBox(width: size * 0.25),
          textWidget,
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          emblem,
          SizedBox(height: size * 0.2),
          textWidget,
        ],
      );
    }
  }
}

class _HapoPayLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Outer subtle gradient ring
    final outerRingPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF7C4DFF), Color(0xFF00D4A1)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.04;
    canvas.drawCircle(center, radius * 0.94, outerRingPaint);

    // Background disc with vibrant gradient
    final discPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF7C4DFF), Color(0xFF00D4A1)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: center, radius: radius * 0.82))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.82, discPaint);

    // "H" Letterform (white pillars + crossbar)
    final hPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.96)
      ..style = PaintingStyle.fill;

    final pillarWidth = size.width * 0.125;
    final pillarHeight = size.height * 0.406;
    final pillarRadius = Radius.circular(size.width * 0.04);
    final topY = size.height * 0.297;

    // Left Pillar
    final leftX = size.width * 0.25;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(leftX, topY, pillarWidth, pillarHeight),
        pillarRadius,
      ),
      hPaint,
    );

    // Right Pillar
    final rightX = size.width * 0.625;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(rightX, topY, pillarWidth, pillarHeight),
        pillarRadius,
      ),
      hPaint,
    );

    // Crossbar
    final barHeight = size.height * 0.11;
    final barY = size.height * 0.445;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(leftX, barY, size.width * 0.5, barHeight),
        pillarRadius,
      ),
      hPaint,
    );

    // Sparkle / Accent dot
    final dotPaint = Paint()
      ..color = const Color(0xFF00D4A1).withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.828, size.height * 0.203),
      size.width * 0.045,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
