import 'package:expense_tracker/features/transaction/domain/entities/spending_summary.dart';
import 'package:expense_tracker/features/transaction/domain/entities/transaction.dart';
import 'package:expense_tracker/features/transaction/domain/entities/transaction_status.dart';
import 'package:expense_tracker/features/transaction/domain/entities/transaction_type.dart';
import 'package:expense_tracker/features/transaction/domain/usecases/transaction_usecases.dart';
import 'package:expense_tracker/injection_container.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionStreamProvider = StreamProvider<List<Transaction>>((ref) {
  return sl<GetAllTransactions>().watch();
});

enum TxFilter { all, income, expense, subscription }

final txFilterProvider = StateProvider<TxFilter>((ref) => TxFilter.all);

final filteredTransactionsProvider =
    Provider<AsyncValue<List<Transaction>>>((ref) {
  final all = ref.watch(transactionStreamProvider);
  final filter = ref.watch(txFilterProvider);
  return all.whenData((list) {
    switch (filter) {
      case TxFilter.all:
        return list;
      case TxFilter.income:
        return list.where((t) => t.type == TransactionType.income).toList();
      case TxFilter.expense:
        return list.where((t) => t.type == TransactionType.expense).toList();
      case TxFilter.subscription:
        return list
            .where((t) => t.type == TransactionType.subscription)
            .toList();
    }
  });
});

final spendingSummaryProvider = Provider<AsyncValue<SpendingSummary>>((ref) {
  final all = ref.watch(transactionStreamProvider);
  return all.whenData((list) => sl<GetSpendingSummary>().call(list));
});

final weeklySpendingProvider = Provider<AsyncValue<List<double>>>((ref) {
  final all = ref.watch(transactionStreamProvider);
  return all.whenData((list) {
    final now = DateTime.now();
    final points = List<double>.filled(7, 0);
    for (int i = 0; i < 7; i++) {
      final day = now.subtract(Duration(days: 6 - i));
      points[i] = list
          .where((t) =>
              t.isDebit &&
              t.date.year == day.year &&
              t.date.month == day.month &&
              t.date.day == day.day)
          .fold(0.0, (sum, t) => sum + t.amount);
    }
    return points;
  });
});

final searchQueryProvider = StateProvider<String>((ref) => '');
final searchResultProvider = FutureProvider<List<Transaction>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];
  return sl<SearchTransactions>().call(query);
});

final transactionActionsProvider = Provider((ref) => TransactionActions());

class TransactionActions {
  Future<void> add(Transaction tx) => sl<AddTransaction>().call(tx);
  Future<void> update(Transaction tx) => sl<UpdateTransaction>().call(tx);
  Future<void> delete(String id) => sl<DeleteTransaction>().call(id);
  Future<void> settle(String id) =>
      sl<UpdateTransactionStatus>().call(id, TransactionStatus.settled);
}
