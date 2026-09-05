import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../presentation/screens/models/transaction_record_model.dart';

class FamilyLedgerState {
  final String filterChild; // 'all', 'Amara', 'Kwame'
  final String filterStatus; // 'all', 'approved', 'flagged'
  final List<TxnRecord> allTransactions;

  const FamilyLedgerState({
    this.filterChild = 'all',
    this.filterStatus = 'all',
    this.allTransactions = const [
      TxnRecord(
        child: 'Amara',
        merchant: 'School Canteen',
        amount: -4.50,
        date: 'Today',
        time: '12:30',
        cat: '🍔',
        status: 'approved',
      ),
      TxnRecord(
        child: 'Kwame',
        merchant: 'Stationery World',
        amount: -12.00,
        date: 'Today',
        time: '10:15',
        cat: '📚',
        status: 'approved',
      ),
      TxnRecord(
        child: 'Amara',
        merchant: 'Weekly Allowance',
        amount: 50.00,
        date: 'Today',
        time: '9:00',
        cat: '💸',
        status: 'approved',
      ),
      TxnRecord(
        child: 'Kwame',
        merchant: 'Weekly Allowance',
        amount: 30.00,
        date: 'Today',
        time: '9:00',
        cat: '💸',
        status: 'approved',
      ),
      TxnRecord(
        child: 'Kwame',
        merchant: 'Game Shop',
        amount: -18.00,
        date: 'Yesterday',
        time: '16:20',
        cat: '🎮',
        status: 'flagged',
      ),
      TxnRecord(
        child: 'Amara',
        merchant: 'Bus Pass',
        amount: -15.00,
        date: 'Mon',
        time: '7:45',
        cat: '🚌',
        status: 'approved',
      ),
      TxnRecord(
        child: 'Amara',
        merchant: 'Health Clinic',
        amount: -8.00,
        date: 'Mon',
        time: '14:00',
        cat: '🏥',
        status: 'approved',
      ),
      TxnRecord(
        child: 'Kwame',
        merchant: 'Lunch Break',
        amount: -5.50,
        date: 'Mon',
        time: '12:30',
        cat: '🍔',
        status: 'approved',
      ),
      TxnRecord(
        child: 'Amara',
        merchant: 'Art Supplies',
        amount: -22.00,
        date: 'Sun',
        time: '11:00',
        cat: '🎨',
        status: 'approved',
      ),
      TxnRecord(
        child: 'Kwame',
        merchant: 'Books R Us',
        amount: -9.00,
        date: 'Sun',
        time: '13:45',
        cat: '📚',
        status: 'approved',
      ),
    ],
  });

  List<TxnRecord> get filteredTransactions {
    return allTransactions.where((t) {
      if (filterChild != 'all' && t.child != filterChild) return false;
      if (filterStatus != 'all' && t.status != filterStatus) return false;
      return true;
    }).toList();
  }

  double get totalIn => filteredTransactions
      .where((t) => t.amount > 0)
      .fold<double>(0.0, (sum, t) => sum + t.amount);

  double get totalOut => filteredTransactions
      .where((t) => t.amount < 0)
      .fold<double>(0.0, (sum, t) => sum + t.amount.abs());

  Map<String, List<TxnRecord>> get groupedByDate {
    final Map<String, List<TxnRecord>> map = {};
    for (final t in filteredTransactions) {
      map.putIfAbsent(t.date, () => []).add(t);
    }
    return map;
  }

  FamilyLedgerState copyWith({
    String? filterChild,
    String? filterStatus,
    List<TxnRecord>? allTransactions,
  }) {
    return FamilyLedgerState(
      filterChild: filterChild ?? this.filterChild,
      filterStatus: filterStatus ?? this.filterStatus,
      allTransactions: allTransactions ?? this.allTransactions,
    );
  }
}

class FamilyLedgerNotifier extends Notifier<FamilyLedgerState> {
  @override
  FamilyLedgerState build() => const FamilyLedgerState();

  void setFilterChild(String child) {
    state = state.copyWith(filterChild: child);
  }

  void setFilterStatus(String status) {
    state = state.copyWith(filterStatus: status);
  }
}

final familyLedgerProvider =
    NotifierProvider<FamilyLedgerNotifier, FamilyLedgerState>(
  FamilyLedgerNotifier.new,
);
