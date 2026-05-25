import 'package:equatable/equatable.dart';

/// Summary ringkasan untuk dashboard & analytics
class SpendingSummary extends Equatable {
  final double totalIncome;
  final double totalExpense;
  final double totalSubscription;
  final Map<String, double> byCategory; // categoryId → total amount

  const SpendingSummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.totalSubscription,
    required this.byCategory,
  });

  double get totalBalance => totalIncome - totalExpense - totalSubscription;
  double get totalSpent => totalExpense + totalSubscription;

  /// Persentase pengeluaran per kategori (0.0–1.0)
  double percentageFor(String categoryId) {
    if (totalSpent == 0) return 0;
    return (byCategory[categoryId] ?? 0) / totalSpent;
  }

  static const empty = SpendingSummary(
    totalIncome: 0,
    totalExpense: 0,
    totalSubscription: 0,
    byCategory: {},
  );

  @override
  List<Object?> get props =>
      [totalIncome, totalExpense, totalSubscription, byCategory];
}
