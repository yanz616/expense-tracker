import 'package:expense_tracker/core/constants/app_constants.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/transaction_type.dart';
import '../../domain/entities/transaction_status.dart';
import '../models/transaction_model.dart';

class TransactionLocalDataSource {
  Box<TransactionModel> get _box =>
      Hive.box<TransactionModel>(AppConstants.boxTransactions);

  List<Transaction> getAll() {
    return _box.values.map((m) => m.toEntity()).toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // terbaru dulu
  }

  List<Transaction> getByType(TransactionType type) =>
      getAll().where((t) => t.type == type).toList();

  List<Transaction> getByDateRange(DateTime from, DateTime to) => getAll()
      .where((t) =>
          t.date.isAfter(from.subtract(const Duration(seconds: 1))) &&
          t.date.isBefore(to.add(const Duration(days: 1))))
      .toList();

  List<Transaction> search(String query) {
    final q = query.toLowerCase();
    return getAll()
        .where((t) =>
            t.title.toLowerCase().contains(q) ||
            (t.description?.toLowerCase().contains(q) ?? false))
        .toList();
  }

  Future<void> add(Transaction tx) =>
      _box.put(tx.id, TransactionModel.fromEntity(tx));

  Future<void> update(Transaction tx) {
    final model = TransactionModel.fromEntity(tx);
    return _box.put(tx.id, model);
  }

  Future<void> delete(String id) => _box.delete(id);

  Future<void> updateStatus(String id, TransactionStatus status) {
    final model = _box.get(id);
    if (model == null) return Future.value();
    model.statusIndex = status.index;
    return model.save();
  }

  Future<void> clearAll() => _box.clear();

  /// Stream reaktif — UI rebuild otomatis saat data berubah
  Stream<List<Transaction>> watchAll() => _box.watch().map((_) => getAll());
}
