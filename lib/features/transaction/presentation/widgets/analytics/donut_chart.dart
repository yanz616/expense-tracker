import 'package:expense_tracker/core/theme/app_colors.dart';
import 'package:expense_tracker/core/theme/app_text_styles.dart';
import 'package:expense_tracker/core/utils/currency_formatter.dart';
import 'package:expense_tracker/features/transaction/domain/entities/category.dart';
import 'package:expense_tracker/features/transaction/domain/entities/spending_summary.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DonutChart extends StatefulWidget {
  final SpendingSummary summary;
  final List<Category> categories;

  const DonutChart({
    super.key,
    required this.summary,
    required this.categories,
  });

  @override
  State<DonutChart> createState() => _DonutChartState();
}

class _DonutChartState extends State<DonutChart> {
  int _touched = -1;

  @override
  Widget build(BuildContext context) {
    final sections = _buildSections();

    return SizedBox(
      height: 260,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 3,
              centerSpaceRadius: 80,
              startDegreeOffset: -90,
              pieTouchData: PieTouchData(
                touchCallback: (event, response) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        response == null ||
                        response.touchedSection == null) {
                      _touched = -1;
                      return;
                    }
                    _touched = response.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              sections: sections.isEmpty
                  ? [
                      PieChartSectionData(
                        value: 1,
                        color: AppColors.textDim,
                        radius: 28,
                        showTitle: false,
                      )
                    ]
                  : sections,
            ),
          ),
          // Center label
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('TOTAL SPENT',
                  style: AppTextStyles.labelSmall.copyWith(letterSpacing: 1.5)),
              const SizedBox(height: 4),
              Text(
                CurrencyFormatter.format(widget.summary.totalSpent),
                style: AppTextStyles.displayMedium.copyWith(fontSize: 22),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    final byCategory = widget.summary.byCategory;
    if (byCategory.isEmpty) return [];

    return widget.categories.where((c) => (byCategory[c.id] ?? 0) > 0).map((c) {
      final amount = byCategory[c.id]!;
      final pct = widget.summary.percentageFor(c.id);
      final color = Color(c.colorValue);
      final idx = widget.categories.indexOf(c);
      final isTouched = idx == _touched;

      return PieChartSectionData(
        value: amount,
        color: color,
        radius: isTouched ? 36 : 28,
        showTitle: isTouched,
        title: '${(pct * 100).toStringAsFixed(0)}%',
        titleStyle: AppTextStyles.labelSmall
            .copyWith(color: AppColors.bgPrimary, fontWeight: FontWeight.w700),
      );
    }).toList();
  }
}
