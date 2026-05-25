import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/transaction_provider.dart';
import '../widgets/common/app_bar_widget.dart';
import '../widgets/common/section_header.dart';
import '../widgets/dashboard/balance_header.dart';
import '../widgets/dashboard/weekly_chart.dart';
import '../widgets/dashboard/transaction_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txAsync = ref.watch(transactionStreamProvider);

    return Scaffold(
      appBar: CommandCenterAppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: AppColors.textMuted, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.blue,
        backgroundColor: AppColors.bgSurface,
        onRefresh: () async => ref.invalidate(transactionStreamProvider),
        child: CustomScrollView(
          slivers: [
            // Balance + Summary cards
            const SliverToBoxAdapter(child: BalanceHeader()),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Weekly chart
            const SliverToBoxAdapter(child: WeeklySpendingChart()),
            const SliverToBoxAdapter(child: SizedBox(height: 4)),

            // Activity Log header
            SliverToBoxAdapter(
              child: SectionHeader(
                title: 'ACTIVITY LOG',
                actionLabel: 'HISTORY',
                onAction: () => context.go(AppConstants.navHistory),
              ),
            ),

            // Transaction list
            txAsync.when(
              loading: () => const SliverToBoxAdapter(
                  child: Center(
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.blue))),
              error: (e, _) => SliverToBoxAdapter(
                  child: Center(
                      child:
                          Text('Error: $e', style: AppTextStyles.labelMedium))),
              data: (list) {
                if (list.isEmpty)
                  return const SliverToBoxAdapter(child: _EmptyState());

                // Hanya tampilkan 5 terbaru di dashboard
                final recent = list.take(5).toList();
                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TransactionCard(
                          transaction: recent[i],
                          onTap: () => context.go(
                            AppConstants.navEditTx,
                            extra: recent[i],
                          ),
                        ),
                      ),
                      childCount: recent.length,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      // FAB
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go(AppConstants.navAddTx),
        backgroundColor: AppColors.blue,
        foregroundColor: AppColors.bgPrimary,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          const Icon(Icons.receipt_long_outlined,
              size: 48, color: AppColors.textDim),
          const SizedBox(height: 12),
          Text('No transactions yet',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textMuted)),
          const SizedBox(height: 6),
          const Text('Tap + to add your first one',
              style: AppTextStyles.labelSmall),
        ],
      ),
    );
  }
}
