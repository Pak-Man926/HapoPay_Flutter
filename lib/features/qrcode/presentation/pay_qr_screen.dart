import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hapopay/core/constants/constants.dart';
import 'package:hapopay/features/qrcode/presentation/widgets/alt_auth_options.dart';
import 'package:hapopay/features/qrcode/presentation/widgets/security_badge.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/theme/tokens.dart';
import '../../../shared/widgets/app_primary_button.dart';
import '../providers/pay_qr_provider.dart';

export '../providers/pay_qr_provider.dart' show PayStep;

class PayQrScreen extends ConsumerStatefulWidget {
  final bool isEmbeddedInShell;

  const PayQrScreen({
    super.key,
    this.isEmbeddedInShell = false,
  });

  @override
  ConsumerState<PayQrScreen> createState() => _PayQrScreenState();
}

class _PayQrScreenState extends ConsumerState<PayQrScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _scanController;
  late final Animation<double> _scanAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final payQrState = ref.watch(payQrProvider);
    final step = payQrState.step;
    final bioDone = payQrState.bioDone;
    final countdown = payQrState.countdown;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? AppTokens.darkBackground : AppTokens.lightBackground;
    final foregroundColor =
        isDark ? AppTokens.darkForeground : AppTokens.lightForeground;
    final mutedForeground =
        isDark ? AppTokens.darkMutedForeground : AppTokens.lightMutedForeground;
    final cardColor = isDark ? AppTokens.darkCard : AppTokens.lightCard;
    final borderColor = isDark ? AppTokens.darkBorder : AppTokens.lightBorder;
    final secondaryBg =
        isDark ? AppTokens.darkSecondary : AppTokens.lightSecondary;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: widget.isEmbeddedInShell
          ? null
          : AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded,
                    color: foregroundColor, size: 20),
                onPressed: () => context.pop(),
              ),
              title: Text(
                step == PayStep.biometric
                    ? 'Verify Identity'
                    : step == PayStep.qr
                        ? 'Scan to Pay'
                        : 'Payment Confirmation',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: foregroundColor,
                ),
              ),
              centerTitle: true,
            ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildCurrentStep(
            context,
            step: step,
            bioDone: bioDone,
            countdown: countdown,
            isDark: isDark,
            foregroundColor: foregroundColor,
            mutedForeground: mutedForeground,
            cardColor: cardColor,
            borderColor: borderColor,
            secondaryBg: secondaryBg,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Step 1: Biometric Verification
  // ---------------------------------------------------------------------------

  Widget _buildBiometricStep({
    required bool bioDone,
    required Color foregroundColor,
    required Color mutedForeground,
    required Color cardColor,
    required Color borderColor,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Column(
        children: [
          const Spacing.vertical(10),
          Text(
            'Verify Identity',
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: foregroundColor,
            ),
          ),
          const Spacing.vertical(4),
          Text(
            'Use your fingerprint or face to confirm',
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: mutedForeground,
            ),
          ),
          const Spacing.vertical(48),

          // Animated Pulsing Biometric Sensor
          Center(
            child: SizedBox(
              width: 180,
              height: 180,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer ripple
                  if (!bioDone)
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Container(
                          width: 120 + (_pulseController.value * 50),
                          height: 120 + (_pulseController.value * 50),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTokens.primary.withValues(
                              alpha: (1.0 - _pulseController.value) * 0.2,
                            ),
                          ),
                        );
                      },
                    ),

                  // Middle ripple
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: bioDone
                          ? AppTokens.accent.withValues(alpha: 0.18)
                          : AppTokens.primary.withValues(alpha: 0.15),
                    ),
                  ),

                  // Touch ID center button
                  GestureDetector(
                    onTap: () =>
                        ref.read(payQrProvider.notifier).authenticate(),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: bioDone
                            ? AppTokens.accentGradient
                            : AppTokens.primaryGradient,
                        boxShadow: [
                          BoxShadow(
                            color: (bioDone
                                    ? AppTokens.accent
                                    : AppTokens.primary)
                                .withValues(alpha: 0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            bioDone
                                ? Icons.check_rounded
                                : Icons.fingerprint_rounded,
                            color: Colors.white,
                            size: 38,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            bioDone ? 'Verified' : 'Touch ID',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Spacing.vertical(24),

          Text(
            bioDone
                ? 'Generating secure QR code...'
                : 'Tap the sensor to authenticate',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: mutedForeground,
            ),
          ),

          const Spacing.vertical(48),

          // Alternative verification methods
          Text(
            'OR USE ANOTHER METHOD',
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: mutedForeground,
              letterSpacing: 0.5,
            ),
          ),
          const Spacing.vertical(12),

          AltAuthOption(
            emoji: '👁️',
            label: 'Face Recognition',
            cardColor: cardColor,
            borderColor: borderColor,
            foregroundColor: foregroundColor,
            onTap: () => ref.read(payQrProvider.notifier).authenticate(),
          ),
          const Spacing.vertical(10),
          AltAuthOption(
            emoji: '🔢',
            label: 'Enter PIN',
            cardColor: cardColor,
            borderColor: borderColor,
            foregroundColor: foregroundColor,
            onTap: () => ref.read(payQrProvider.notifier).authenticate(),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Step 2: Dynamic QR Code
  // ---------------------------------------------------------------------------
  Widget _buildQrStep({
    required int countdown,
    required Color foregroundColor,
    required Color mutedForeground,
    required Color cardColor,
    required Color borderColor,
  }) {
    final pct = countdown / 60.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        children: [
          Text(
            'Scan to Pay',
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: foregroundColor,
            ),
          ),
          const Spacing.vertical(2),
          Text(
            'Show this QR code at the checkout terminal',
            style: GoogleFonts.outfit(
              fontSize: 13,
              color: mutedForeground,
            ),
          ),
          const Spacing.vertical(24),

          // QR Container with laser scan line & timer ring
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: AppTokens.borderRadius3xl,
              border: Border.all(color: AppTokens.primary, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppTokens.primary.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                // QR Box with Animated Scan Line
                ClipRRect(
                  borderRadius: AppTokens.borderRadiusLg,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(12),
                    child: Stack(
                      children: [
                        QrImageView(
                          data:
                              'hapopay://pay?amount=12.00&merchant=School+Canteen&exp=60',
                          version: QrVersions.auto,
                          size: 190.0,
                          eyeStyle: const QrEyeStyle(
                            eyeShape: QrEyeShape.square,
                            color: Color(0xFF080B12),
                          ),
                          dataModuleStyle: const QrDataModuleStyle(
                            dataModuleShape: QrDataModuleShape.square,
                            color: Color(0xFF080B12),
                          ),
                        ),
                        // Animated Laser Scan Beam
                        Positioned.fill(
                          child: AnimatedBuilder(
                            animation: _scanAnimation,
                            builder: (context, child) {
                              return Align(
                                alignment: Alignment(
                                    0, (_scanAnimation.value * 2) - 1),
                                child: Container(
                                  height: 2.5,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        AppTokens.primary,
                                        AppTokens.accent,
                                        Colors.transparent,
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTokens.primary
                                            .withValues(alpha: 0.8),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacing.vertical(16),

                // Countdown Timer Arc
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        value: pct,
                        strokeWidth: 2.5,
                        backgroundColor: AppTokens.darkBorder,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            AppTokens.primary),
                      ),
                    ),
                    const Spacing.horizontal(8),
                    Text(
                      'Expires in ${countdown}s',
                      style: GoogleFonts.dmMono(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: mutedForeground,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Spacing.vertical(20),

          // Max Transaction Cap
          Text(
            'Max transaction',
            style: GoogleFonts.outfit(
              fontSize: 12,
              color: mutedForeground,
            ),
          ),
          const Spacing.vertical(2),
          Text(
            '\$50.00',
            style: GoogleFonts.dmMono(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: foregroundColor,
            ),
          ),

          const Spacing.vertical(20),

          // Security Badges Row
          Row(
            children: [
              Expanded(
                child: SecurityBadge(
                  icon: Icons.shield_outlined,
                  iconColor: AppTokens.accent,
                  label: '256-bit encrypted',
                  cardColor: cardColor,
                  borderColor: borderColor,
                  textColor: mutedForeground,
                ),
              ),
              const Spacing.vertical(8),
              Expanded(
                child: SecurityBadge(
                  icon: Icons.lock_outline_rounded,
                  iconColor: AppTokens.primary,
                  label: 'Biometric verified',
                  cardColor: cardColor,
                  borderColor: borderColor,
                  textColor: mutedForeground,
                ),
              ),
            ],
          ),

          const Spacing.vertical(24),

          // Simulate Scan CTA Button
          AppPrimaryButton(
            label: 'Simulate Terminal Scan  ↗',
            onPressed: () =>
                ref.read(payQrProvider.notifier).simulateScanSuccess(),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Step 3: Success Confirmation
  // ---------------------------------------------------------------------------
  Widget _buildSuccessStep({
    required Color foregroundColor,
    required Color mutedForeground,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),

          // Large Success Checkmark Badge
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTokens.accent.withValues(alpha: 0.15),
              border: Border.all(color: AppTokens.accent, width: 2.5),
            ),
            child: const Center(
              child:
                  Icon(Icons.check_rounded, color: AppTokens.accent, size: 54),
            ),
          ),

          const Spacing.vertical(24),

          Text(
            'Payment Sent!',
            style: GoogleFonts.outfit(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: foregroundColor,
            ),
          ),
          const Spacing.vertical(6),
          Text(
            '\$12.00 to School Canteen',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: mutedForeground,
            ),
          ),

          const Spacing.vertical(20),

          // Rewards Earned Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppTokens.accent.withValues(alpha: 0.15),
              borderRadius: AppTokens.borderRadiusFull,
              border: Border.all(
                color: AppTokens.accent.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              '+5 reward points earned 🎉',
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppTokens.accent,
              ),
            ),
          ),

          const Spacer(),

          // Done Button
          AppPrimaryButton(
            label: 'Done',
            onPressed: () {
              ref.read(payQrProvider.notifier).reset();
              context.go('/student');
            },
          ),
          const Spacing.vertical(16),
        ],
      ),
    );
  }

  Widget _buildCurrentStep(
    BuildContext context, {
    required PayStep step,
    required bool bioDone,
    required int countdown,
    required bool isDark,
    required Color foregroundColor,
    required Color mutedForeground,
    required Color cardColor,
    required Color borderColor,
    required Color secondaryBg,
  }) {
    switch (step) {
      case PayStep.biometric:
        return _buildBiometricStep(
          bioDone: bioDone,
          foregroundColor: foregroundColor,
          mutedForeground: mutedForeground,
          cardColor: cardColor,
          borderColor: borderColor,
        );
      case PayStep.qr:
        return _buildQrStep(
          countdown: countdown,
          foregroundColor: foregroundColor,
          mutedForeground: mutedForeground,
          cardColor: cardColor,
          borderColor: borderColor,
        );
      case PayStep.success:
        return _buildSuccessStep(
          foregroundColor: foregroundColor,
          mutedForeground: mutedForeground,
        );
    }
  }
}
