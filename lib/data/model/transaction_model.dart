import 'package:expense_tracker/domain/entity/transaction.dart';
import 'package:intl/intl.dart';

final class TransactionModel {
  TransactionModel({
    required this.id,
    required this.amount,
    required this.merchant,
    required this.category,
    required this.date,
    required this.status,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] is int ? map['id'] : int.parse(map['id'].toString()),
      amount: (map['amount'] as double?) ?? 0.0,
      merchant: map['merchant'] ?? '',
      category: map['category'] ?? '',
      date: DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
      status: map['status'] ?? 'pending',
    );
  }

  factory TransactionModel.fromEntity(Transaction entity) {
    return TransactionModel(
      id: entity.id,
      amount: entity.amount,
      merchant: entity.merchant,
      category: entity.category,
      date: entity.date,
      status: entity.status,
    );
  }

  final int id;
  final double amount;
  final String merchant;
  final String category;
  final DateTime date;
  final String status;

  Map<String, dynamic> toJson() {
    return {
      "id": id.toString(),
      "amount": amount,
      "merchant": merchant,
      "category": category,
      "date": DateFormat('yyyy-MM-dd').format(date),
      "status": status,
    };
  }

  Transaction toEntity() {
    return Transaction(
      id: id,
      amount: amount,
      merchant: merchant,
      category: category,
      date: date,
      status: status,
    );
  }
}
