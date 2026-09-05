import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hapopay/core/constants/constants.dart';
import '../../providers/spending_limits_provider.dart';
import '../../../student/providers/student_account_provider.dart';

class SpendingLimitsScreen extends ConsumerWidget {
  const SpendingLimitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountAsync = ref.watch(studentAccountProvider);
    final limitsState = ref.watch(spendingLimitsProvider);
    final theme = Theme.of(context);

    final isCardLocked = limitsState.isCardLocked;
    final currentSliderValue = limitsState.currentLimit;
    final isSaving = limitsState.isSaving;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spending Controls'),
      ),
      body: accountAsync.when(
        loading: () => Center(
            child: CircularProgressIndicator(color: theme.colorScheme.primary)),
        error: (err, _) => Center(
          child: Text('Error loading limits: $err',
              style: TextStyle(color: theme.colorScheme.error)),
        ),
        data: (_) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manage Student Card Controls',
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacing.vertical(10),
                Text(
                  'Instantly adjust spending limits or freeze the debit card to prevent unauthorized purchases.',
                  style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      fontSize: 14),
                ),
                const Spacing.vertical(30),

                // Card Freeze Container
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isCardLocked
                        ? Colors.red.withValues(alpha: 0.08)
                        : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isCardLocked
                          ? Colors.redAccent.withValues(alpha: 0.4)
                          : theme.colorScheme.onSurface.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isCardLocked
                              ? Colors.redAccent.withValues(alpha: 0.12)
                              : theme.colorScheme.onSurface
                                  .withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isCardLocked ? Icons.lock : Icons.lock_open,
                          color: isCardLocked
                              ? Colors.redAccent
                              : theme.colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                        ),
                      ),
                      const Spacing.horizontal(15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Card Lock',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const Spacing.vertical(4),
                            Text(
                              'Suspend all payments immediately',
                              style: TextStyle(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.5),
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        activeThumbColor: theme.colorScheme.error,
                        value: isCardLocked,
                        onChanged: (val) {
                          ref
                              .read(spendingLimitsProvider.notifier)
                              .setCardLocked(val);
                        },
                      ),
                    ],
                  ),
                ),
                const Spacing.vertical(25),
                // Limit Settings Container (Disabled when locked)
                Opacity(
                  opacity: isCardLocked ? 0.4 : 1.0,
                  child: IgnorePointer(
                    ignoring: isCardLocked,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.12)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Daily spending cap',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              Icon(Icons.speed,
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.3)),
                            ],
                          ),
                          Divider(
                              height: 24,
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.12)),
                          const Spacing.vertical(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Limit Value',
                                  style: TextStyle(
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.7))),
                              Text(
                                '\$${currentSliderValue.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          const Spacing.vertical(15),
                          Slider(
                            value: currentSliderValue,
                            min: 5.0,
                            max: 200.0,
                            divisions: 39,
                            activeColor: theme.colorScheme.primary,
                            inactiveColor: theme.colorScheme.onSurface
                                .withValues(alpha: 0.12),
                            label: '\$${currentSliderValue.round()}',
                            onChanged: (double value) {
                              ref
                                  .read(spendingLimitsProvider.notifier)
                                  .setLimit(value);
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('\$5.00',
                                  style: TextStyle(
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.4),
                                      fontSize: 12)),
                              Text('\$200.00',
                                  style: TextStyle(
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.4),
                                      fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const Spacing.vertical(50),

                // Save button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 8,
                    ),
                    onPressed: isSaving
                        ? null
                        : () async {
                            final success = await ref
                                .read(spendingLimitsProvider.notifier)
                                .saveLimit();
                            if (context.mounted) {
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                        'Spending limits updated successfully.'),
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                );
                                Navigator.pop(context);
                              } else {
                                final err = ref
                                    .read(spendingLimitsProvider)
                                    .errorMessage;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Failed to update limits: $err'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                    child: isSaving
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Save Spending Controls',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
