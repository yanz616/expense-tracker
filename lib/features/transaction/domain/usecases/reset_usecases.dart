import '../entities/archived_period.dart';
import '../repositories/i_settings_repository.dart';
import '../repositories/i_transaction_repository.dart';
import 'transaction_usecases.dart';
import 'package:uuid/uuid.dart';

class CheckAndResetIfDue {
  final ISettingsRepository _settings;
  final ITransactionRepository _transactions;
  final GetSpendingSummary _getSummary;

  CheckAndResetIfDue(this._settings, this._transactions, this._getSummary);

  Future<bool> call() async {
    final isDue = await _settings.isDueForReset();
    if (!isDue) return false;

    // 1. Ambil semua transaksi periode ini
    final txList = await _transactions.getAll();
    final summary = _getSummary(txList);
    final lastReset = await _settings.getLastResetDate();
    final now = DateTime.now();

    // 2. Arsipkan sebelum reset
    final period = ArchivedPeriod(
      id: const Uuid().v4(),
      periodStart: lastReset ?? now.subtract(const Duration(days: 30)),
      periodEnd: now,
      totalIncome: summary.totalIncome,
      totalExpense: summary.totalExpense,
      totalSubscription: summary.totalSubscription,
      transactionCount: txList.length,
      archivedAt: now,
    );
    await _settings.archivePeriod(period);

    // 3. Reset data & simpan tanggal baru
    await _transactions.clearAll();
    await _settings.setLastResetDate(now);

    return true; // reset terjadi
  }
}
