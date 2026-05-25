import '../entities/archived_period.dart';

abstract class ISettingsRepository {
  /// Periode reset dalam hari (30, 90, 180)
  Future<int>      getResetPeriodDays();
  Future<void>     setResetPeriodDays(int days);

  Future<DateTime?> getLastResetDate();
  Future<void>      setLastResetDate(DateTime date);

  /// Cek apakah sudah waktunya reset
  Future<bool>     isDueForReset();

  /// Arsip periode & reset
  Future<void>     archivePeriod(ArchivedPeriod period);
  Future<List<ArchivedPeriod>> getArchivedPeriods();

  Future<bool>     isOnboardingDone();
  Future<void>     setOnboardingDone();
}
