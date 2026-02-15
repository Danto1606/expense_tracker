final class Transaction {
  Transaction({
    required this.id,
    required this.amount,
    required this.merchant,
    required this.category,
    required this.date,
    required this.status,
  });

  final int id;
  final double amount;
  final String merchant;
  final String category;
  final DateTime date;
  final String status;
}
