import 'package:expense_tracker/core/theme/app_colors.dart';
import 'package:expense_tracker/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/transaction_provider.dart';

class FilterPills extends ConsumerWidget {
  const FilterPills({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(txFilterProvider);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: TxFilter.values.map((f) {
          final isActive = f == current;
          return GestureDetector(
            onTap: () => ref.read(txFilterProvider.notifier).state = f,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.blue.withOpacity(0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: isActive ? AppColors.blue : AppColors.border,
                    width: isActive ? 1.5 : 1),
              ),
              child: Text(
                f.name.toUpperCase(),
                style: AppTextStyles.labelSmall.copyWith(
                  color: isActive ? AppColors.blue : AppColors.textMuted,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
