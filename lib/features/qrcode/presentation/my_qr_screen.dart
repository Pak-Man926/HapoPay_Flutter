import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hapopay/core/constants/constants.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/theme/tokens.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/my_qr_provider.dart';

class MyQrScreen extends ConsumerStatefulWidget {
  const MyQrScreen({super.key});

  @override
  ConsumerState<MyQrScreen> createState() => _MyQrScreenState();
}

class _MyQrScreenState extends ConsumerState<MyQrScreen> {
  final _amountController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(authProvider.select((s) => s.user));
    final myQrState = ref.watch(myQrProvider);

    final backgroundColor =
        isDark ? AppTokens.darkBackground : AppTokens.lightBackground;
    final foregroundColor =
        isDark ? AppTokens.darkForeground : AppTokens.lightForeground;
    final mutedForeground =
        isDark ? AppTokens.darkMutedForeground : AppTokens.lightMutedForeground;
    final cardColor = isDark ? AppTokens.darkCard : AppTokens.lightCard;
    final borderColor = isDark ? AppTokens.darkBorder : AppTokens.lightBorder;

    final studentId = user?.id ?? 'student_123';
    final studentName = user?.fullName ?? 'Amara Mensah';

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: foregroundColor, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'My QR Code',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: foregroundColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          children: [
            Text(
              'Receive Payments & Allowances',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: foregroundColor,
              ),
            ),
            const Spacing.vertical(4),
            Text(
              'Show this QR code to a parent or peer to receive money',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 13,
                color: mutedForeground,
              ),
            ),
            const Spacing.vertical(24),

            // QR Code Display Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: AppTokens.borderRadius3xl,
                border: Border.all(color: AppTokens.accent, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppTokens.accent.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: AppTokens.borderRadiusLg,
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(12),
                      child: QrImageView(
                        data: myQrState.generatePayload(studentId, studentName),
                        version: QrVersions.auto,
                        size: 200.0,
                        eyeStyle: const QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: Color(0xFF080B12),
                        ),
                        dataModuleStyle: const QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: Color(0xFF080B12),
                        ),
                      ),
                    ),
                  ),
                  const Spacing.vertical(16),
                  Text(
                    studentName,
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: foregroundColor,
                    ),
                  ),
                  const Spacing.vertical(2),
                  Text(
                    'Scan to pay HapoPay user',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: mutedForeground,
                    ),
                  ),
                ],
              ),
            ),

            const Spacing.vertical(24),

            // Request Details Form Card
            Container(
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
                    'Request Details',
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: foregroundColor,
                    ),
                  ),
                  const Spacing.vertical(14),
                  Text(
                    'AMOUNT (\$)',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: mutedForeground,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Spacing.vertical(6),
                  TextField(
                    controller: _amountController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    style: GoogleFonts.dmMono(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: foregroundColor,
                    ),
                    decoration: const InputDecoration(
                      hintText: '0.00',
                      prefixIcon: Icon(Icons.attach_money_rounded, size: 20),
                    ),
                    onChanged: (val) {
                      ref.read(myQrProvider.notifier).setAmount(
                            double.tryParse(val) ?? 0.0,
                          );
                    },
                  ),
                  const Spacing.vertical(14),
                  Text(
                    'DESCRIPTION / NOTE',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: mutedForeground,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Spacing.vertical(6),
                  TextField(
                    controller: _descController,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: foregroundColor,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'What is this for?',
                      prefixIcon: Icon(Icons.edit_note_rounded, size: 20),
                    ),
                    onChanged: (val) {
                      ref.read(myQrProvider.notifier).setDescription(val);
                    },
                  ),
                ],
              ),
            ),

            const Spacing.vertical(24),
          ],
        ),
      ),
    );
  }
}
