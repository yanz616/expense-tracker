import 'package:expense_tracker/features/transaction/data/datasources/category_local_ds.dart';
import 'package:expense_tracker/features/transaction/data/datasources/settings_local_ds.dart';
import 'package:expense_tracker/features/transaction/data/datasources/transaction_local_ds.dart';
import 'package:expense_tracker/features/transaction/data/repositories/category_repository_impl.dart';
import 'package:expense_tracker/features/transaction/data/repositories/settings_repository_impl.dart';
import 'package:expense_tracker/features/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:expense_tracker/features/transaction/domain/repositories/i_category_repository.dart';
import 'package:expense_tracker/features/transaction/domain/repositories/i_settings_repository.dart';
import 'package:expense_tracker/features/transaction/domain/repositories/i_transaction_repository.dart';
import 'package:expense_tracker/features/transaction/domain/usecases/category_usecases.dart';
import 'package:expense_tracker/features/transaction/domain/usecases/reset_usecases.dart';
import 'package:expense_tracker/features/transaction/domain/usecases/transaction_usecases.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  // === DATA SOURCES ===
  sl.registerLazySingleton(() => TransactionLocalDataSource());
  sl.registerLazySingleton(() => CategoryLocalDataSource());
  sl.registerLazySingleton(() => SettingsLocalDataSource());

  // === REPOSITORIES ===
  sl.registerLazySingleton<ITransactionRepository>(
      () => TransactionRepositoryImpl(sl()));
  sl.registerLazySingleton<ICategoryRepository>(
      () => CategoryRepositoryImpl(sl()));
  sl.registerLazySingleton<ISettingsRepository>(
      () => SettingsRepositoryImpl(sl()));

  // === USE CASES — Transaction ===
  sl.registerLazySingleton(() => GetAllTransactions(sl()));
  sl.registerLazySingleton(() => GetTransactionsByType(sl()));
  sl.registerLazySingleton(() => GetTransactionsByDateRange(sl()));
  sl.registerLazySingleton(() => SearchTransactions(sl()));
  sl.registerLazySingleton(() => AddTransaction(sl()));
  sl.registerLazySingleton(() => UpdateTransaction(sl()));
  sl.registerLazySingleton(() => DeleteTransaction(sl()));
  sl.registerLazySingleton(() => UpdateTransactionStatus(sl()));
  sl.registerLazySingleton(() => GetSpendingSummary());

  // === USE CASES — Category ===
  sl.registerLazySingleton(() => GetAllCategories(sl()));
  sl.registerLazySingleton(() => AddCategory(sl()));
  sl.registerLazySingleton(() => UpdateCategory(sl()));
  sl.registerLazySingleton(() => DeleteCategory(sl()));

  // === USE CASES — Reset ===
  sl.registerLazySingleton(() => CheckAndResetIfDue(sl(), sl(), sl()));

  // === SEED default categories saat pertama install ===
  await sl<CategoryLocalDataSource>().seedDefaults();
}
