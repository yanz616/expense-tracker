import 'package:expense_tracker/core/theme/app_colors.dart';
import 'package:expense_tracker/core/theme/app_text_styles.dart';
import 'package:expense_tracker/features/transaction/domain/entities/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/category_provider.dart';

class CategoryGrid extends ConsumerWidget {
  final String? selectedId;
  final ValueChanged<Category> onSelected;

  const CategoryGrid({
    super.key,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catAsync = ref.watch(categoryStreamProvider);

    return catAsync.when(
      loading: () => const SizedBox(
          height: 80,
          child: Center(
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: AppColors.blue))),
      error: (_, __) => const SizedBox.shrink(),
      data: (categories) => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemCount: categories.length,
        itemBuilder: (_, i) {
          final cat = categories[i];
          final isActive = cat.id == selectedId;
          final color = Color(cat.colorValue);
          return GestureDetector(
            onTap: () => onSelected(cat),
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isActive
                        ? color.withOpacity(0.25)
                        : AppColors.bgSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: isActive ? color : AppColors.border,
                        width: isActive ? 1.5 : 1),
                  ),
                  child: Icon(_iconFromString(cat.icon),
                      color: isActive ? color : AppColors.textMuted, size: 24),
                ),
                const SizedBox(height: 5),
                Text(cat.name,
                    style: AppTextStyles.labelSmall.copyWith(
                        color: isActive ? color : AppColors.textMuted),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          );
        },
      ),
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
