import 'package:expense_tracker/core/constants/app_constants.dart';
import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final _fmt = NumberFormat.currency(
    locale: AppConstants.currencyLocale,
    symbol: '${AppConstants.currencySymbol} ',
    decimalDigits: 0,
  );

  static final _compact = NumberFormat.compactCurrency(
    locale: AppConstants.currencyLocale,
    symbol: '${AppConstants.currencySymbol} ',
    decimalDigits: 1,
  );

  /// Rp 1.200.000
  static String format(double amount) => _fmt.format(amount.abs());

  /// Rp 1,2jt  (untuk chart / label pendek)
  static String compact(double amount) => _compact.format(amount.abs());

  /// +Rp 1.200.000 / -Rp 1.200.000
  static String signed(double amount) {
    final prefix = amount >= 0 ? '+' : '-';
    return '$prefix${format(amount)}';
  }
}
