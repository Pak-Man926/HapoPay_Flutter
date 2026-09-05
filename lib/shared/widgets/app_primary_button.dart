import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/tokens.dart';

class AppPrimaryButton extends StatelessWidget {
  final String label;
  final Widget? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color? textColor;
  final double height;
  final double? width;
  final double borderRadius;

  const AppPrimaryButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.gradient,
    this.backgroundColor,
    this.textColor,
    this.height = 52,
    this.width,
    this.borderRadius = AppTokens.radiusLg,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveDisabled = isDisabled || isLoading;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final defaultGradient = effectiveDisabled
        ? null
        : (gradient ??
            (backgroundColor == null ? AppTokens.primaryGradient : null));

    final effectiveBgColor = effectiveDisabled
        ? (isDark ? AppTokens.darkMuted : AppTokens.lightMuted)
        : backgroundColor;

    final effectiveTextColor = effectiveDisabled
        ? (isDark
            ? AppTokens.darkMutedForeground
            : AppTokens.lightMutedForeground)
        : (textColor ?? Colors.white);

    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: effectiveBgColor,
        gradient: defaultGradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: effectiveDisabled
            ? null
            : [
                BoxShadow(
                  color: AppTokens.primaryDark.withValues(alpha: 0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: effectiveDisabled ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(effectiveTextColor),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        icon!,
                        const SizedBox(width: 8),
                      ],
                      Text(
                        label,
                        style: GoogleFonts.outfit(
                          color: effectiveTextColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
