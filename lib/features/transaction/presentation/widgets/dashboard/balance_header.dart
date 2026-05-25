import 'package:expense_tracker/core/theme/app_colors.dart';
import 'package:expense_tracker/core/theme/app_text_styles.dart';
import 'package:expense_tracker/core/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/transaction_provider.dart';

class BalanceHeader extends ConsumerWidget {
  const BalanceHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(spendingSummaryProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: summaryAsync.when(
        loading: () => const _BalanceShimmer(),
        error: (_, __) => const SizedBox.shrink(),
        data: (summary) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('TOTAL AVAILABLE ASSETS',
                style: AppTextStyles.headingMedium),
            const SizedBox(height: 6),
            Text(
              CurrencyFormatter.format(summary.totalBalance),
              style: AppTextStyles.displayLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                    child: _SummaryCard(
                  label: 'INCOME',
                  amount: summary.totalIncome,
                  isDebit: false,
                  icon: Icons.arrow_downward_rounded,
                )),
                const SizedBox(width: 12),
                Expanded(
                    child: _SummaryCard(
                  label: 'EXPENSES',
                  amount: summary.totalSpent,
                  isDebit: true,
                  icon: Icons.arrow_upward_rounded,
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final double amount;
  final bool isDebit;
  final IconData icon;

  const _SummaryCard({
    required this.label,
    required this.amount,
    required this.isDebit,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDebit ? AppColors.expense : AppColors.income;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Text(label, style: AppTextStyles.labelSmall.copyWith(color: color)),
          ]),
          const SizedBox(height: 6),
          Text(
            '${isDebit ? "-" : "+"}${CurrencyFormatter.format(amount)}',
            style: AppTextStyles.bodyLarge.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _BalanceShimmer extends StatelessWidget {
  const _BalanceShimmer();
  @override
  Widget build(BuildContext context) => const SizedBox(
        height: 120,
        child: Center(
            child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.blue,
        )),
      );
}
