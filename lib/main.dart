import 'package:expense_tracker/features/transaction/data/models/archived_period_model.dart';
import 'package:expense_tracker/features/transaction/data/models/category_model.dart';
import 'package:expense_tracker/features/transaction/data/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/constants/app_constants.dart';
// import 'core/theme/app_theme.dart';
import 'injection_container.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Init Hive
  await Hive.initFlutter();

  // 2. Register Adapters
  Hive.registerAdapter(TransactionModelAdapter());
  Hive.registerAdapter(CategoryModelAdapter());
  Hive.registerAdapter(ArchivedPeriodModelAdapter());

  // 3. Open Boxes (dengan type)
  await Future.wait([
    Hive.openBox<TransactionModel>(AppConstants.boxTransactions),
    Hive.openBox<CategoryModel>(AppConstants.boxCategories),
    Hive.openBox<ArchivedPeriodModel>(AppConstants.boxArchivedPeriods),
    Hive.openBox(AppConstants.boxSettings),
  ]);

  // 4. Setup Dependency Injection
  await setupDependencies();

  runApp(
    const ProviderScope(
      child: ExpenseTrackerApp(),
    ),
  );
}
