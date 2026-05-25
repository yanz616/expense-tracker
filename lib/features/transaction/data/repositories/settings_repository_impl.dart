import '../../domain/entities/archived_period.dart';
import '../../domain/repositories/i_settings_repository.dart';
import '../datasources/settings_local_ds.dart';

class SettingsRepositoryImpl implements ISettingsRepository {
  final SettingsLocalDataSource _ds;
  SettingsRepositoryImpl(this._ds);

  @override
  Future<int> getResetPeriodDays() async => _ds.getResetPeriodDays();

  @override
  Future<void> setResetPeriodDays(int days) => _ds.setResetPeriodDays(days);

  @override
  Future<DateTime?> getLastResetDate() async => _ds.getLastResetDate();

  @override
  Future<void> setLastResetDate(DateTime date) => _ds.setLastResetDate(date);

  @override
  Future<bool> isDueForReset() async => _ds.isDueForReset();

  @override
  Future<void> archivePeriod(ArchivedPeriod period) =>
      _ds.archivePeriod(period);

  @override
  Future<List<ArchivedPeriod>> getArchivedPeriods() async =>
      _ds.getArchivedPeriods();

  @override
  Future<bool> isOnboardingDone() async => _ds.isOnboardingDone();

  @override
  Future<void> setOnboardingDone() => _ds.setOnboardingDone();
}
