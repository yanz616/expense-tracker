import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/transaction_provider.dart';
import '../widgets/common/app_bar_widget.dart';
import '../widgets/history/filter_pills.dart';
import '../widgets/history/grouped_tx_list.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  bool _showSearch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommandCenterAppBar(
        actions: [
          IconButton(
            icon: Icon(
              _showSearch ? Icons.search_off_outlined : Icons.search,
              color: _showSearch ? AppColors.blue : AppColors.textMuted,
              size: 22,
            ),
            onPressed: () {
              setState(() => _showSearch = !_showSearch);
              if (!_showSearch) {
                ref.read(searchQueryProvider.notifier).state = '';
              }
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Text('HISTORY',
                  style: AppTextStyles.headingLarge.copyWith(fontSize: 28)),
            ),
          ),

          // Search bar
          if (_showSearch)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: TextField(
                  autofocus: true,
                  style: AppTextStyles.bodyMedium,
                  cursorColor: AppColors.blue,
                  decoration: InputDecoration(
                    hintText: 'Search transactions...',
                    prefixIcon: const Icon(Icons.search,
                        color: AppColors.textMuted, size: 18),
                    suffixIcon: ref.watch(searchQueryProvider).isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear,
                                color: AppColors.textMuted, size: 16),
                            onPressed: () => ref
                                .read(searchQueryProvider.notifier)
                                .state = '',
                          )
                        : null,
                  ),
                  onChanged: (v) =>
                      ref.read(searchQueryProvider.notifier).state = v,
                ),
              ),
            ),

          // Filter pills
          const SliverToBoxAdapter(child: FilterPills()),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          // Grouped list
          const GroupedTxList(),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
