class ParentTxn {
  final String childName;
  final String merchant;
  final double amount;
  final String time;
  final String cat;
  final bool approved;

  const ParentTxn({
    required this.childName,
    required this.merchant,
    required this.amount,
    required this.time,
    required this.cat,
    required this.approved,
  });
}
