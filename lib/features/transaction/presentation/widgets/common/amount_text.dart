import 'package:expense_tracker/core/theme/app_text_styles.dart';
import 'package:expense_tracker/core/utils/currency_formatter.dart';
import 'package:flutter/material.dart';

class AmountText extends StatelessWidget {
  final double amount;
  final bool isDebit;
  final double fontSize;
  final bool showSign;

  const AmountText({
    super.key,
    required this.amount,
    required this.isDebit,
    this.fontSize = 15,
    this.showSign = true,
  });

  @override
  Widget build(BuildContext context) {
    final sign = showSign ? (isDebit ? '-' : '+') : '';
    return Text(
      '$sign${CurrencyFormatter.format(amount)}',
      style: AppTextStyles.amount(isExpense: isDebit, size: fontSize),
    );
  }
}
