import 'package:expense_tracker/features/transaction/domain/entities/archived_period.dart';
import 'package:expense_tracker/features/transaction/domain/repositories/i_settings_repository.dart';
import 'package:expense_tracker/injection_container.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final resetPeriodProvider = FutureProvider<int>(
    (ref) => sl<ISettingsRepository>().getResetPeriodDays());

final archivedPeriodsProvider = FutureProvider<List<ArchivedPeriod>>(
    (ref) => sl<ISettingsRepository>().getArchivedPeriods());

final settingsActionsProvider = Provider((ref) => SettingsActions(ref));

class SettingsActions {
  final Ref _ref;
  SettingsActions(this._ref);

  Future<void> setResetPeriod(int days) async {
    await sl<ISettingsRepository>().setResetPeriodDays(days);
    _ref.invalidate(resetPeriodProvider);
  }
}
