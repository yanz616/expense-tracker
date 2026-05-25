import 'package:expense_tracker/core/theme/app_colors.dart';
import 'package:expense_tracker/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class EmptyActivityLog extends StatelessWidget {
  const EmptyActivityLog({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(children: [
        Icon(Icons.receipt_long_outlined, size: 44, color: AppColors.textDim),
        SizedBox(height: 12),
        Text('ACTIVITY LOG EMPTY', style: AppTextStyles.headingMedium),
        SizedBox(height: 6),
        Text('Tap + to record your first transaction',
            style: AppTextStyles.labelMedium),
      ]),
    );
  }
}

class EmptyHistory extends StatelessWidget {
  const EmptyHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 80),
      child: Column(children: [
        Icon(Icons.history_outlined, size: 44, color: AppColors.textDim),
        SizedBox(height: 12),
        Text('NO TRANSACTIONS FOUND', style: AppTextStyles.headingMedium),
        SizedBox(height: 6),
        Text('Your transaction history will appear here',
            style: AppTextStyles.labelMedium),
      ]),
    );
  }
}

class EmptyAnalytics extends StatelessWidget {
  const EmptyAnalytics({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 60),
      child: Column(children: [
        Icon(Icons.bar_chart_outlined, size: 44, color: AppColors.textDim),
        SizedBox(height: 12),
        Text('NO DATA THIS MONTH', style: AppTextStyles.headingMedium),
        SizedBox(height: 6),
        Text('Add transactions to see your analytics',
            style: AppTextStyles.labelMedium),
      ]),
    );
  }
}
