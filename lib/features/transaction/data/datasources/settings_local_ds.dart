import 'package:expense_tracker/core/constants/app_constants.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/archived_period.dart';
import '../models/archived_period_model.dart';

class SettingsLocalDataSource {
  Box get _settings => Hive.box(AppConstants.boxSettings);
  Box<ArchivedPeriodModel> get _archive =>
      Hive.box<ArchivedPeriodModel>(AppConstants.boxArchivedPeriods);

  // === RESET PERIOD ===
  int getResetPeriodDays() => _settings.get(AppConstants.keyResetPeriodDays,
      defaultValue: AppConstants.defaultResetDays) as int;

  Future<void> setResetPeriodDays(int days) =>
      _settings.put(AppConstants.keyResetPeriodDays, days);

  // === LAST RESET DATE ===
  DateTime? getLastResetDate() {
    final raw = _settings.get(AppConstants.keyLastResetDate);
    return raw as DateTime?;
  }

  Future<void> setLastResetDate(DateTime date) =>
      _settings.put(AppConstants.keyLastResetDate, date);

  // === CEK APAKAH SUDAH WAKTUNYA RESET ===
  bool isDueForReset() {
    final last = getLastResetDate();
    if (last == null) return false;
    final periodDays = getResetPeriodDays();
    final nextReset = last.add(Duration(days: periodDays));
    return DateTime.now().isAfter(nextReset);
  }

  // === ARCHIVE ===
  Future<void> archivePeriod(ArchivedPeriod period) =>
      _archive.put(period.id, ArchivedPeriodModel.fromEntity(period));

  List<ArchivedPeriod> getArchivedPeriods() =>
      _archive.values.map((m) => m.toEntity()).toList()
        ..sort((a, b) => b.periodEnd.compareTo(a.periodEnd));

  // === ONBOARDING ===
  bool isOnboardingDone() =>
      _settings.get(AppConstants.keyOnboardingDone, defaultValue: false)
          as bool;

  Future<void> setOnboardingDone() =>
      _settings.put(AppConstants.keyOnboardingDone, true);
}
