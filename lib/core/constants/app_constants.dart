class AppConstants {
  AppConstants._();

  // Hive Box Names
  static const boxTransactions = 'transactions';
  static const boxCategories = 'categories';
  static const boxArchivedPeriods = 'archived_periods';
  static const boxSettings = 'settings';

  // Hive Type IDs
  static const tidTransaction = 0;
  static const tidCategory = 1;
  static const tidTransactionType = 2;
  static const tidTransactionStatus = 3;
  static const tidArchivedPeriod = 4;

  // Settings Keys
  static const keyLastResetDate = 'last_reset_date';
  static const keyResetPeriodDays = 'reset_period_days';
  static const keyOnboardingDone = 'onboarding_done';

  // Default Reset Period
  static const defaultResetDays = 30; // 1 bulan default

  // Currency
  static const currencySymbol = 'Rp';
  static const currencyLocale = 'id_ID';

  // Navigation
  static const navDashboard = '/';
  static const navHistory = '/history';
  static const navAnalytics = '/analytics';
  static const navProfile = '/profile';
  static const navAddTx = '/add-transaction';
  static const navEditTx = '/edit-transaction';
  static const navSettings = '/settings';
}
