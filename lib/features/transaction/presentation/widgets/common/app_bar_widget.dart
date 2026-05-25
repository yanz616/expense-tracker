import 'package:expense_tracker/core/theme/app_colors.dart';
import 'package:expense_tracker/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class CommandCenterAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final List<Widget>? actions;
  const CommandCenterAppBar({super.key, this.actions});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          const Icon(Icons.terminal, size: 16, color: AppColors.blue),
          const SizedBox(width: 8),
          Text('COMMAND_CENTER',
              style: AppTextStyles.headingMedium.copyWith(
                color: AppColors.textPrimary,
                letterSpacing: 1.5,
              )),
        ],
      ),
      actions: actions,
    );
  }
}
