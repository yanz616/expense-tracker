import 'package:expense_tracker/features/transaction/domain/entities/transaction.dart';
import 'package:expense_tracker/features/transaction/presentation/screens/add_transaction_screen.dart';
import 'package:expense_tracker/features/transaction/presentation/screens/analytics_screen.dart';
import 'package:expense_tracker/features/transaction/presentation/screens/dashboard_screen.dart';
import 'package:expense_tracker/features/transaction/presentation/screens/history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';

// Uncomment saat step berikutnya selesai:
// import '../screens/history_screen.dart';
// import '../screens/analytics_screen.dart';
// import '../screens/profile_screen.dart';
// import '../screens/add_transaction_screen.dart';
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppConstants.navDashboard,
    routes: [
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: AppConstants.navDashboard,
            pageBuilder: (_, __) =>
                const NoTransitionPage(child: DashboardScreen()),
          ),
          GoRoute(
            path: AppConstants.navHistory,
            pageBuilder: (_, __) =>
                const NoTransitionPage(child: HistoryScreen()),
          ),
          GoRoute(
            path: AppConstants.navAnalytics,
            pageBuilder: (_, __) =>
                const NoTransitionPage(child: AnalyticsScreen()),
          ),
          GoRoute(
            path: AppConstants.navProfile,
            pageBuilder: (_, __) => const NoTransitionPage(
              child: Scaffold(body: Center(child: Text('Profile — Step 7'))),
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppConstants.navAddTx,
        pageBuilder: (_, __) => CustomTransitionPage(
          child: const AddTransactionScreen(),
          transitionsBuilder: (_, anim, __, child) => SlideTransition(
            position: Tween(begin: const Offset(0, 1), end: Offset.zero)
                .animate(
                    CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
            child: child,
          ),
        ),
      ),
      GoRoute(
        path: AppConstants.navEditTx,
        pageBuilder: (_, state) => CustomTransitionPage(
          child: AddTransactionScreen(existing: state.extra as Transaction?),
          transitionsBuilder: (_, anim, __, child) => SlideTransition(
            position: Tween(begin: const Offset(0, 1), end: Offset.zero)
                .animate(
                    CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
            child: child,
          ),
        ),
      ),
    ],
  );
});

class MainShell extends ConsumerWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  int _idx(BuildContext context) {
    final loc = GoRouterState.of(context).matchedLocation;
    if (loc.startsWith(AppConstants.navHistory)) return 1;
    if (loc.startsWith(AppConstants.navAnalytics)) return 2;
    if (loc.startsWith(AppConstants.navProfile)) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.border))),
        child: BottomNavigationBar(
          currentIndex: _idx(context),
          onTap: (i) {
            switch (i) {
              case 0:
                context.go(AppConstants.navDashboard);
              case 1:
                context.go(AppConstants.navHistory);
              case 2:
                context.go(AppConstants.navAnalytics);
              case 3:
                context.go(AppConstants.navProfile);
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.history_outlined), label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart_outlined), label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline), label: ''),
          ],
        ),
      ),
    );
  }
}
