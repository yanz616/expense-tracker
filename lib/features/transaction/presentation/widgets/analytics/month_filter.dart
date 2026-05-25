import 'package:expense_tracker/core/theme/app_colors.dart';
import 'package:expense_tracker/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class MonthFilter extends StatelessWidget {
  final int selectedMonth; // 1–12
  final int selectedYear;
  final ValueChanged<int> onMonthChanged;

  const MonthFilter({
    super.key,
    required this.selectedMonth,
    required this.selectedYear,
    required this.onMonthChanged,
  });

  static const _months = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC'
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(12, (i) {
          final month = i + 1;
          final isActive = month == selectedMonth;
          return GestureDetector(
            onTap: () => onMonthChanged(month),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.blue.withOpacity(0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: isActive ? AppColors.blue : AppColors.border,
                    width: isActive ? 1.5 : 1),
              ),
              child: Text(_months[i],
                  style: AppTextStyles.labelSmall.copyWith(
                    color: isActive ? AppColors.blue : AppColors.textMuted,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                    letterSpacing: 1.5,
                  )),
            ),
          );
        }),
      ),
    );
  }
}
