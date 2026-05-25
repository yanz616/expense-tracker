import 'package:expense_tracker/core/theme/app_colors.dart';
import 'package:expense_tracker/core/theme/app_text_styles.dart';
import 'package:expense_tracker/features/transaction/domain/entities/transaction_type.dart';
import 'package:flutter/material.dart';

class TypeToggle extends StatelessWidget {
  final TransactionType selected;
  final ValueChanged<TransactionType> onChanged;

  const TypeToggle(
      {super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: TransactionType.values.map((type) {
        final isActive = selected == type;
        final color = switch (type) {
          TransactionType.income => AppColors.income,
          TransactionType.expense => AppColors.expense,
          TransactionType.subscription => AppColors.purple,
        };
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(type),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(
                  right: type != TransactionType.subscription ? 8 : 0),
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                color: isActive ? color.withOpacity(0.15) : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: isActive ? color : AppColors.border,
                    width: isActive ? 1.5 : 1),
              ),
              child: Text(type.label,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: isActive ? color : AppColors.textMuted,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                    letterSpacing: 1.5,
                  )),
            ),
          ),
        );
      }).toList(),
    );
  }
}
