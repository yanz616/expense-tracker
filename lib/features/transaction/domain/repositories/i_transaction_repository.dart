import '../entities/transaction.dart';
import '../entities/transaction_type.dart';
import '../entities/transaction_status.dart';

/// Contract (abstract) — Data layer wajib implement ini
abstract class ITransactionRepository {
  /// Ambil semua transaksi (periode aktif), diurutkan terbaru dulu
  Future<List<Transaction>> getAll();

  /// Filter berdasarkan tipe (income / expense / subscription)
  Future<List<Transaction>> getByType(TransactionType type);

  /// Filter berdasarkan rentang tanggal
  Future<List<Transaction>> getByDateRange(DateTime from, DateTime to);

  /// Cari berdasarkan judul / deskripsi
  Future<List<Transaction>> search(String query);

  /// Tambah transaksi baru
  Future<void> add(Transaction transaction);

  /// Update transaksi yang sudah ada
  Future<void> update(Transaction transaction);

  /// Hapus berdasarkan ID
  Future<void> delete(String id);

  /// Update status (Pending → Settled)
  Future<void> updateStatus(String id, TransactionStatus status);

  /// Hapus semua (dipanggil saat reset periode)
  Future<void> clearAll();

  /// Stream untuk reactive update di UI
  Stream<List<Transaction>> watchAll();
}
