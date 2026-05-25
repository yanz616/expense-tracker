import 'package:expense_tracker/core/theme/app_colors.dart';
import 'package:expense_tracker/core/theme/app_text_styles.dart';
import 'package:expense_tracker/core/utils/currency_formatter.dart';
import 'package:expense_tracker/features/transaction/domain/entities/transaction.dart';
import 'package:expense_tracker/features/transaction/domain/entities/transaction_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/category_provider.dart';

class TransactionCard extends ConsumerWidget {
  final Transaction transaction;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const TransactionCard({
    super.key,
    required this.transaction,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catMapAsync = ref.watch(categoryMapProvider);
    final category = catMapAsync.valueOrNull?[transaction.categoryId];
    final catColor =
        category != null ? Color(category.colorValue) : AppColors.blue;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // Icon kategori
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: catColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_iconFromString(category?.icon ?? 'grid_view'),
                  color: catColor, size: 20),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(transaction.title,
                      style: AppTextStyles.bodyMedium
                          .copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 3),
                  Text(
                    '${_timeLabel(transaction.date)} · ${category?.name ?? ""}',
                    style: AppTextStyles.labelSmall,
                  ),
                ],
              ),
            ),

            // Amount + Status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${transaction.isDebit ? "-" : "+"}${CurrencyFormatter.format(transaction.amount)}',
                  style: AppTextStyles.amount(
                      isExpense: transaction.isDebit, size: 13),
                ),
                const SizedBox(height: 3),
                Text(
                  transaction.status.label,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: transaction.status == TransactionStatus.pending
                        ? AppColors.pending
                        : AppColors.settled,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _timeLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);
    if (d == today) return 'Today';
    if (d == today.subtract(const Duration(days: 1))) return 'Yesterday';
    return '${date.day} ${_months[date.month - 1]}';
  }

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  IconData _iconFromString(String name) {
    const map = <String, IconData>{
      'restaurant': Icons.restaurant,
      'commute': Icons.commute,
      'shopping_bag': Icons.shopping_bag_outlined,
      'gamepad': Icons.gamepad_outlined,
      'receipt_long': Icons.receipt_long_outlined,
      'medical_services': Icons.medical_services_outlined,
      'science': Icons.science_outlined,
      'grid_view': Icons.grid_view_outlined,
    };
    return map[name] ?? Icons.circle_outlined;
  }
}
