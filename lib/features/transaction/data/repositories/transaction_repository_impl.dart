import '../../domain/entities/transaction.dart';
import '../../domain/entities/transaction_type.dart';
import '../../domain/entities/transaction_status.dart';
import '../../domain/repositories/i_transaction_repository.dart';
import '../datasources/transaction_local_ds.dart';

class TransactionRepositoryImpl implements ITransactionRepository {
  final TransactionLocalDataSource _ds;
  TransactionRepositoryImpl(this._ds);

  @override
  Future<List<Transaction>> getAll() async => _ds.getAll();

  @override
  Future<List<Transaction>> getByType(TransactionType type) async =>
      _ds.getByType(type);

  @override
  Future<List<Transaction>> getByDateRange(DateTime from, DateTime to) async =>
      _ds.getByDateRange(from, to);

  @override
  Future<List<Transaction>> search(String query) async => _ds.search(query);

  @override
  Future<void> add(Transaction transaction) => _ds.add(transaction);

  @override
  Future<void> update(Transaction transaction) => _ds.update(transaction);

  @override
  Future<void> delete(String id) => _ds.delete(id);

  @override
  Future<void> updateStatus(String id, TransactionStatus status) =>
      _ds.updateStatus(id, status);

  @override
  Future<void> clearAll() => _ds.clearAll();

  @override
  Stream<List<Transaction>> watchAll() => _ds.watchAll();
}
