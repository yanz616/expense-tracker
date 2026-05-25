import 'package:expense_tracker/core/constants/app_constants.dart';
import 'package:expense_tracker/core/theme/app_colors.dart';
import 'package:expense_tracker/core/theme/app_text_styles.dart';
import 'package:expense_tracker/features/transaction/domain/entities/transaction.dart';
import 'package:expense_tracker/features/transaction/presentation/widgets/common/empty_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/transaction_provider.dart';
import '../dashboard/transaction_card.dart';

class GroupedTxList extends ConsumerWidget {
  const GroupedTxList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtered = ref.watch(filteredTransactionsProvider);

    return filtered.when(
      loading: () => const SliverToBoxAdapter(
        child: Center(
            child: Padding(
          padding: EdgeInsets.all(40),
          child:
              CircularProgressIndicator(strokeWidth: 2, color: AppColors.blue),
        )),
      ),
      error: (e, _) => SliverToBoxAdapter(
          child: Center(child: Text('$e', style: AppTextStyles.labelMedium))),
      data: (list) {
        // ← EMPTY STATE
        if (list.isEmpty) {
          return const SliverToBoxAdapter(child: EmptyHistory());
        }

        final groups = <String, List<Transaction>>{};
        for (final tx in list) {
          groups.putIfAbsent(_dateKey(tx.date), () => []).add(tx);
        }
        final keys = groups.keys.toList();

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) {
              final key = keys[i];
              final items = groups[key]!;
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(key,
                              style: AppTextStyles.labelSmall
                                  .copyWith(letterSpacing: 1.5)),
                        ),
                        const Expanded(child: Divider()),
                      ]),
                    ),
                    ...items.map((tx) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: TransactionCard(
                            transaction: tx,
                            onTap: () =>
                                context.push(AppConstants.navEditTx, extra: tx),
                            onLongPress: () => _confirmSettle(context, ref, tx),
                          ),
                        )),
                  ],
                ),
              );
            },
            childCount: keys.length,
          ),
        );
      },
    );
  }

  String _dateKey(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);
    if (d == today) return 'TODAY — ${_fmt(date)}';
    if (d == today.subtract(const Duration(days: 1)))
      return 'YESTERDAY — ${_fmt(date)}';
    return _fmt(date).toUpperCase();
  }

  String _fmt(DateTime d) {
    const m = [
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
    return '${m[d.month - 1]} ${d.day}';
  }

  void _confirmSettle(BuildContext context, WidgetRef ref, Transaction tx) {
    if (tx.status.index == 1) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgOverlay,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Mark as Settled?', style: AppTextStyles.bodyLarge),
          const SizedBox(height: 8),
          Text(tx.title,
              style: AppTextStyles.labelMedium.copyWith(color: AppColors.blue)),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.border)),
                child: Text('CANCEL',
                    style: AppTextStyles.labelSmall
                        .copyWith(color: AppColors.textMuted)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await ref.read(transactionActionsProvider).settle(tx.id);
                },
                child: const Text('SETTLE'),
              ),
            ),
          ]),
        ]),
      ),
    );
  }
}
