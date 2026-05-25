import '../entities/transaction.dart';
import '../entities/transaction_type.dart';
import '../entities/transaction_status.dart';
import '../entities/spending_summary.dart';
import '../repositories/i_transaction_repository.dart';

class GetAllTransactions {
  final ITransactionRepository _repo;
  GetAllTransactions(this._repo);
  Future<List<Transaction>> call() => _repo.getAll();
  Stream<List<Transaction>> watch() => _repo.watchAll();
}

class GetTransactionsByType {
  final ITransactionRepository _repo;
  GetTransactionsByType(this._repo);
  Future<List<Transaction>> call(TransactionType type) => _repo.getByType(type);
}

class GetTransactionsByDateRange {
  final ITransactionRepository _repo;
  GetTransactionsByDateRange(this._repo);
  Future<List<Transaction>> call(DateTime from, DateTime to) =>
      _repo.getByDateRange(from, to);
}

class SearchTransactions {
  final ITransactionRepository _repo;
  SearchTransactions(this._repo);
  Future<List<Transaction>> call(String query) => _repo.search(query);
}

class AddTransaction {
  final ITransactionRepository _repo;
  AddTransaction(this._repo);
  Future<void> call(Transaction transaction) => _repo.add(transaction);
}

class UpdateTransaction {
  final ITransactionRepository _repo;
  UpdateTransaction(this._repo);
  Future<void> call(Transaction transaction) => _repo.update(transaction);
}

class DeleteTransaction {
  final ITransactionRepository _repo;
  DeleteTransaction(this._repo);
  Future<void> call(String id) => _repo.delete(id);
}

class UpdateTransactionStatus {
  final ITransactionRepository _repo;
  UpdateTransactionStatus(this._repo);
  Future<void> call(String id, TransactionStatus status) =>
      _repo.updateStatus(id, status);
}

/// Hitung SpendingSummary dari list transaksi
class GetSpendingSummary {
  GetSpendingSummary();

  SpendingSummary call(List<Transaction> transactions) {
    double income = 0, expense = 0, subscription = 0;
    final Map<String, double> byCategory = {};

    for (final tx in transactions) {
      switch (tx.type) {
        case TransactionType.income:
          income += tx.amount;
        case TransactionType.expense:
          expense += tx.amount;
          byCategory[tx.categoryId] =
              (byCategory[tx.categoryId] ?? 0) + tx.amount;
        case TransactionType.subscription:
          subscription += tx.amount;
          byCategory[tx.categoryId] =
              (byCategory[tx.categoryId] ?? 0) + tx.amount;
      }
    }

    return SpendingSummary(
      totalIncome: income,
      totalExpense: expense,
      totalSubscription: subscription,
      byCategory: byCategory,
    );
  }
}
