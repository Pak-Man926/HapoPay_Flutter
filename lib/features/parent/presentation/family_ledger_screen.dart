import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../student/providers/student_account_provider.dart';

class FamilyLedgerScreen extends ConsumerWidget {
  const FamilyLedgerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountAsync = ref.watch(studentAccountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Ledger'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(studentAccountProvider.notifier).refresh(),
          ),
        ],
      ),
      body: accountAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Text('Error loading transactions: $err',
              style: const TextStyle(color: Colors.red)),
        ),
        data: (account) {
          final txs = account.transactions;
          final theme = Theme.of(context);

          if (txs.isEmpty) {
            return Center(
              child: Text(
                'No transactions recorded yet.',
                style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 16),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(24.0),
            itemCount: txs.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final tx = txs[index];
              final isDebit = tx.type == 'debit';
              final formattedTime =
                  DateFormat('MMM d, h:mm a').format(tx.timestamp.toLocal());

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.12)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDebit
                            ? Colors.red.withValues(alpha: 0.12)
                            : Colors.green.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isDebit ? Icons.arrow_outward : Icons.call_received,
                        color: isDebit ? Colors.redAccent : Colors.greenAccent,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tx.description,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formattedTime,
                            style: TextStyle(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.5), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${isDebit ? '-' : '+'}\$${tx.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDebit ? Colors.redAccent : Colors.greenAccent,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
