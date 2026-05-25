import 'package:equatable/equatable.dart';
import 'transaction_type.dart';
import 'transaction_status.dart';

class Transaction extends Equatable {
  final String id;
  final String title;
  final double amount;
  final TransactionType type;
  final TransactionStatus status;
  final String categoryId;
  final DateTime date;
  final String? description;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.status,
    required this.categoryId,
    required this.date,
    this.description,
    required this.createdAt,
    this.updatedAt,
  });

  /// Apakah transaksi ini mengurangi saldo
  bool get isDebit => type.isDebit;

  /// Nilai signed: positif untuk income, negatif untuk expense/subscription
  double get signedAmount => isDebit ? -amount : amount;

  @override
  List<Object?> get props =>
      [id, title, amount, type, status, categoryId, date, description];

  Transaction copyWith({
    String? id,
    String? title,
    double? amount,
    TransactionType? type,
    TransactionStatus? status,
    String? categoryId,
    DateTime? date,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Transaction(
        id: id ?? this.id,
        title: title ?? this.title,
        amount: amount ?? this.amount,
        type: type ?? this.type,
        status: status ?? this.status,
        categoryId: categoryId ?? this.categoryId,
        date: date ?? this.date,
        description: description ?? this.description,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}
