import 'package:expense_tracker/features/transaction/domain/usecases/transaction_usecases.dart';
import 'package:expense_tracker/features/transaction/presentation/widgets/analytics/category_breakdown.dart';
import 'package:expense_tracker/features/transaction/presentation/widgets/analytics/donut_chart.dart';
import 'package:expense_tracker/features/transaction/presentation/widgets/analytics/month_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../injection_container.dart';
import '../providers/category_provider.dart';
import '../widgets/common/app_bar_widget.dart';

// Provider khusus untuk filter bulan di analytics
final analyticsMonthProvider = StateProvider<int>((_) => DateTime.now().month);
final analyticsYearProvider = StateProvider<int>((_) => DateTime.now().year);

final analyticsDataProvider = FutureProvider.autoDispose((ref) async {
  final month = ref.watch(analyticsMonthProvider);
  final year = ref.watch(analyticsYearProvider);

  final from = DateTime(year, month, 1);
  final to = DateTime(year, month + 1, 0); // last day of month

  final txList = await sl<GetTransactionsByDateRange>().call(from, to);
  final summary = sl<GetSpendingSummary>().call(txList);
  return summary;
});

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = ref.watch(analyticsMonthProvider);
    final year = ref.watch(analyticsYearProvider);
    final dataAsync = ref.watch(analyticsDataProvider);
    final catAsync = ref.watch(categoryStreamProvider);

    return Scaffold(
      appBar: CommandCenterAppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: AppColors.textMuted, size: 22),
            onPressed: () {},
          ),
          // Avatar placeholder
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 14,
              backgroundColor: AppColors.bgCard,
              child: const Icon(Icons.person_outline,
                  size: 16, color: AppColors.blue),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('REPORTS',
                      style: AppTextStyles.headingLarge.copyWith(fontSize: 28)),
                  const SizedBox(height: 4),
                  Text('Monthly allocation and expenditure analytics.',
                      style: AppTextStyles.labelMedium),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Month filter
          SliverToBoxAdapter(
            child: MonthFilter(
              selectedMonth: month,
              selectedYear: year,
              onMonthChanged: (m) =>
                  ref.read(analyticsMonthProvider.notifier).state = m,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // Donut chart + total
          SliverToBoxAdapter(
            child: dataAsync.when(
              loading: () => const SizedBox(
                height: 260,
                child: Center(
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppColors.blue)),
              ),
              error: (e, _) =>
                  Center(child: Text('$e', style: AppTextStyles.labelMedium)),
              data: (summary) => catAsync.when(
                loading: () => const SizedBox(height: 260),
                error: (_, __) => const SizedBox(height: 260),
                data: (cats) => DonutChart(
                  summary: summary,
                  categories: cats,
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Income / expense summary row
          SliverToBoxAdapter(
            child: dataAsync.maybeWhen(
              data: (summary) => Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Row(children: [
                  _StatChip(
                    label: 'INCOME',
                    amount: summary.totalIncome,
                    color: AppColors.income,
                    icon: Icons.arrow_downward_rounded,
                  ),
                  const SizedBox(width: 10),
                  _StatChip(
                    label: 'EXPENSE',
                    amount: summary.totalExpense,
                    color: AppColors.expense,
                    icon: Icons.arrow_upward_rounded,
                  ),
                  const SizedBox(width: 10),
                  _StatChip(
                    label: 'SUBS',
                    amount: summary.totalSubscription,
                    color: AppColors.purple,
                    icon: Icons.repeat_rounded,
                  ),
                ]),
              ),
              orElse: () => const SizedBox.shrink(),
            ),
          ),

          // Category breakdown
          SliverToBoxAdapter(
            child: dataAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (summary) => catAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (cats) => CategoryBreakdown(
                  summary: summary,
                  categories: cats,
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final IconData icon;

  const _StatChip({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(icon, size: 11, color: color),
              const SizedBox(width: 4),
              Text(label,
                  style: AppTextStyles.labelSmall
                      .copyWith(color: color, fontSize: 9)),
            ]),
            const SizedBox(height: 4),
            Text(
              amount > 0 ? _compact(amount) : 'Rp 0',
              style: AppTextStyles.labelMedium
                  .copyWith(color: color, fontWeight: FontWeight.w700),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  String _compact(double v) {
    if (v >= 1000000) return 'Rp ${(v / 1000000).toStringAsFixed(1)}jt';
    if (v >= 1000) return 'Rp ${(v / 1000).toStringAsFixed(0)}rb';
    return 'Rp ${v.toStringAsFixed(0)}';
  }
}
