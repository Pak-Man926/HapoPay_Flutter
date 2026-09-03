class TxnRecord {
  final String child;
  final String merchant;
  final double amount;
  final String date;
  final String time;
  final String cat;
  final String status; // 'approved' or 'flagged'

  const TxnRecord({
    required this.child,
    required this.merchant,
    required this.amount,
    required this.date,
    required this.time,
    required this.cat,
    required this.status,
  });
}
