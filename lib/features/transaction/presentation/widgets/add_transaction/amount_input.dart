import 'package:expense_tracker/core/theme/app_colors.dart';
import 'package:expense_tracker/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmountInput extends StatefulWidget {
  final double initialValue;
  final ValueChanged<double> onChanged;

  const AmountInput({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<AmountInput> createState() => _AmountInputState();
}

class _AmountInputState extends State<AmountInput> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(
      text:
          widget.initialValue > 0 ? widget.initialValue.toStringAsFixed(0) : '',
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('INPUT_AMOUNT', style: AppTextStyles.headingMedium),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Rp',
                style: AppTextStyles.displayMedium
                    .copyWith(color: AppColors.textMuted)),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _ctrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: false),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: AppTextStyles.displayLarge,
                cursorColor: AppColors.blue,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: '0',
                  hintStyle: TextStyle(
                    fontSize: 36,
                    color: AppColors.textDim,
                    fontFamily: 'JetBrainsMono',
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (v) => widget.onChanged(double.tryParse(v) ?? 0),
              ),
            ),
          ],
        ),
        const Divider(height: 24),
      ],
    );
  }
}
