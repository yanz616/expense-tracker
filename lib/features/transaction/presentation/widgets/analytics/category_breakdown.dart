import 'package:expense_tracker/core/theme/app_colors.dart';
import 'package:expense_tracker/core/theme/app_text_styles.dart';
import 'package:expense_tracker/core/utils/currency_formatter.dart';
import 'package:expense_tracker/features/transaction/domain/entities/category.dart';
import 'package:expense_tracker/features/transaction/domain/entities/spending_summary.dart';
import 'package:flutter/material.dart';

class CategoryBreakdown extends StatelessWidget {
  final SpendingSummary summary;
  final List<Category> categories;

  const CategoryBreakdown({
    super.key,
    required this.summary,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: categories.map((cat) {
        final amount = summary.byCategory[cat.id] ?? 0;
        final pct = summary.percentageFor(cat.id);
        final color = Color(cat.colorValue);
        final isOver = amount > 0 && pct > 0.3; // >30% dianggap tinggi

        return Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
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
                // Icon
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:
                      Icon(_iconFromString(cat.icon), color: color, size: 16),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(cat.name,
                      style: AppTextStyles.bodyMedium
                          .copyWith(fontWeight: FontWeight.w600)),
                ),
                // Amount — merah jika over budget
                Text(
                  CurrencyFormatter.format(amount),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isOver ? AppColors.red : AppColors.textPrimary,
                  ),
                ),
              ]),
              if (amount > 0) ...[
                const SizedBox(height: 10),
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: pct.clamp(0, 1),
                    backgroundColor: AppColors.textDim,
                    valueColor:
                        AlwaysStoppedAnimation(isOver ? AppColors.red : color),
                    minHeight: 4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Distribution: ${(pct * 100).toStringAsFixed(0)}%',
                  style: AppTextStyles.labelSmall,
                ),
              ] else ...[
                const SizedBox(height: 6),
                Text('No spending detected',
                    style: AppTextStyles.labelSmall
                        .copyWith(color: AppColors.textDim)),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

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
