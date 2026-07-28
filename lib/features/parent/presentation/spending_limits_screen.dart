import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../student/providers/student_account_provider.dart';

class SpendingLimitsScreen extends ConsumerStatefulWidget {
  const SpendingLimitsScreen({super.key});

  @override
  ConsumerState<SpendingLimitsScreen> createState() =>
      _SpendingLimitsScreenState();
}

class _SpendingLimitsScreenState extends ConsumerState<SpendingLimitsScreen> {
  double _currentSliderValue = 50.0;
  bool _isCardLocked = false;
  bool _initialized = false;
  bool _isSaving = false;

  void _initializeState(double currentLimit) {
    if (_initialized) return;
    _currentSliderValue = currentLimit;
    _isCardLocked = currentLimit == 0.0;
    _initialized = true;
  }

  Future<void> _saveLimit() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final targetLimit = _isCardLocked ? 0.0 : _currentSliderValue;
      await ref.read(studentAccountProvider.notifier).updateLimit(targetLimit);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Spending limits updated successfully.'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update limits: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountAsync = ref.watch(studentAccountProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spending Controls'),
      ),
      body: accountAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Text('Error loading limits: $err',
              style: const TextStyle(color: Colors.red)),
        ),
        data: (account) {
          _initializeState(account.dailyLimit);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manage Student Card Controls',
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Instantly adjust spending limits or freeze the debit card to prevent unauthorized purchases.',
                  style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 14),
                ),
                const SizedBox(height: 32),

                // Card Freeze Container
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _isCardLocked
                        ? Colors.red.withValues(alpha: 0.08)
                        : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _isCardLocked
                          ? Colors.redAccent.withValues(alpha: 0.4)
                          : theme.colorScheme.onSurface.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _isCardLocked
                              ? Colors.redAccent.withValues(alpha: 0.12)
                              : theme.colorScheme.onSurface.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isCardLocked ? Icons.lock : Icons.lock_open,
                          color:
                              _isCardLocked ? Colors.redAccent : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(width: 16),
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
                            const SizedBox(height: 4),
                            Text(
                              'Suspend all payments immediately',
                              style: TextStyle(
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5), fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        activeThumbColor: Colors.redAccent,
                        value: _isCardLocked,
                        onChanged: (val) {
                          setState(() {
                            _isCardLocked = val;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Limit Settings Container (Disabled when locked)
                Opacity(
                  opacity: _isCardLocked ? 0.4 : 1.0,
                  child: IgnorePointer(
                    ignoring: _isCardLocked,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.12)),
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
                              Icon(Icons.speed, color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
                            ],
                          ),
                          Divider(height: 24, color: theme.colorScheme.onSurface.withValues(alpha: 0.12)),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Limit Value',
                                  style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.7))),
                              Text(
                                '\$${_currentSliderValue.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Slider(
                            value: _currentSliderValue,
                            min: 5.0,
                            max: 200.0,
                            divisions: 39,
                            activeColor: theme.colorScheme.primary,
                            inactiveColor: theme.colorScheme.onSurface.withValues(alpha: 0.12),
                            label: '\$${_currentSliderValue.round()}',
                            onChanged: (double value) {
                              setState(() {
                                _currentSliderValue = value;
                              });
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('\$5.00',
                                  style: TextStyle(
                                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4), fontSize: 12)),
                              Text('\$200.00',
                                  style: TextStyle(
                                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4), fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 48),

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
                    onPressed: _isSaving ? null : _saveLimit,
                    child: _isSaving
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
