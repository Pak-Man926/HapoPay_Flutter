import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:google_fonts/google_fonts.dart";
import "package:hapopay/core/constants/constants.dart";
import "package:hapopay/core/theme/tokens.dart";
import "package:hapopay/features/qrcode/providers/pay_qr_provider.dart";
import "package:local_auth/local_auth.dart";
import "package:logger/logger.dart";
import "package:pinput/pinput.dart";

class PinAuthentication extends ConsumerWidget {
  final bool isEmbeddedInShell;
  PinAuthentication({super.key, this.isEmbeddedInShell = false});

  final TextEditingController controller = TextEditingController();
  final auth = LocalAuthentication();
  final String pin = "1234"; // Hardcoded PIN for demonstration purposes

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final payQrState = ref.watch(payQrProvider);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? AppTokens.darkBackground
        : AppTokens.lightBackground;
    final foregroundColor = isDark
        ? AppTokens.darkForeground
        : AppTokens.lightForeground;
    final mutedForeground = isDark
        ? AppTokens.darkMutedForeground
        : AppTokens.lightMutedForeground;
    // final cardColor = isDark ? AppTokens.darkCard : AppTokens.lightCard;
    // final borderColor = isDark ? AppTokens.darkBorder : AppTokens.lightBorder;
    // final secondaryBg = isDark
    //     ? AppTokens.darkSecondary
    //     : AppTokens.lightSecondary;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: isEmbeddedInShell
          ? null
          : AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: foregroundColor,
                  size: 20,
                ),
                onPressed: () => context.pop(),
              ),
              title: Text(
                "Enter PIN",
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: foregroundColor,
                ),
              ),
              centerTitle: true,
            ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: .start,
            crossAxisAlignment: .center,
            children: [
              Text(
                " Please enter your 4-digit PIN to proceed.",
                style: GoogleFonts.outfit(fontSize: 14, color: mutedForeground),
              ),
              const Spacing.vertical(32),
              Pinput(
                controller: controller,
                length: 4,
                obscureText: true,
                autofocus: true,
                onCompleted: (enteredPin) {
                  if (enteredPin == pin) {
                    ref.read(payQrProvider.notifier).authenticate();
                    context.pop(); // Close the PIN authentication screen
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Incorrect PIN. Please try again.",
                          style: GoogleFonts.outfit(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    Logger().e("Incorrect PIN entered: $enteredPin");
                    controller.clear(); // Clear the input for retry
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
