import 'package:expense_tracker/core/theme/app_colors.dart';
import 'package:expense_tracker/core/theme/app_text_styles.dart';
import 'package:expense_tracker/core/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/transaction_provider.dart';

class WeeklySpendingChart extends ConsumerWidget {
  const WeeklySpendingChart({super.key});

  static const _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyAsync = ref.watch(weeklySpendingProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text('Weekly Spending Matrix',
                style: AppTextStyles.bodyMedium
                    .copyWith(fontWeight: FontWeight.w700)),
            const Spacer(),
            Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                  color: AppColors.blue, shape: BoxShape.circle),
            ),
            const SizedBox(width: 5),
            Text('Real-time',
                style:
                    AppTextStyles.labelSmall.copyWith(color: AppColors.blue)),
          ]),
          const SizedBox(height: 20),
          weeklyAsync.when(
            loading: () => const SizedBox(
                height: 120,
                child: Center(
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppColors.blue))),
            error: (_, __) => const SizedBox(height: 120),
            data: (points) => SizedBox(
              height: 120,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (val, meta) => Text(
                        _days[val.toInt() % 7],
                        style: AppTextStyles.labelSmall,
                      ),
                    )),
                  ),
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (spots) => spots
                          .map((s) => LineTooltipItem(
                                CurrencyFormatter.compact(s.y),
                                AppTextStyles.labelSmall
                                    .copyWith(color: AppColors.textPrimary),
                              ))
                          .toList(),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                          7, (i) => FlSpot(i.toDouble(), points[i])),
                      isCurved: true,
                      color: AppColors.blue,
                      barWidth: 2,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.blue.withOpacity(0.3),
                            AppColors.blue.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
