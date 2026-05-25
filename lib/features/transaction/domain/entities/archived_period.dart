import 'package:equatable/equatable.dart';

/// Snapshot ringkasan satu periode sebelum reset
class ArchivedPeriod extends Equatable {
  final String id;
  final DateTime periodStart;
  final DateTime periodEnd;
  final double totalIncome;
  final double totalExpense;
  final double totalSubscription;
  final int transactionCount;
  final DateTime archivedAt;

  const ArchivedPeriod({
    required this.id,
    required this.periodStart,
    required this.periodEnd,
    required this.totalIncome,
    required this.totalExpense,
    required this.totalSubscription,
    required this.transactionCount,
    required this.archivedAt,
  });

  double get netBalance => totalIncome - totalExpense - totalSubscription;

  @override
  List<Object?> get props => [id, periodStart, periodEnd];
}
