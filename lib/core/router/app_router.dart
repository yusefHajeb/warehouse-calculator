import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/product/presentation/pages/manage_products_page.dart';
import '../../features/product/presentation/pages/add_edit_product_page.dart';
import '../../features/product/presentation/cubit/product_list_cubit.dart';
import '../../features/product/presentation/cubit/product_form_cubit.dart';
import '../../features/product/domain/entities/product.dart';
import '../../features/calculator/presentation/pages/calculate_order_page.dart';
import '../../features/calculator/presentation/pages/calculation_results_page.dart';
import '../../features/calculator/presentation/cubit/order_calculator_cubit/order_calculator_cubit.dart';
import '../../features/calculator/presentation/cubit/calulation_result_cubit/calculation_result_cubit.dart';
import '../../features/calculator/domain/entities/calculation_result.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../di/injection_container.dart';
import '../widgets/main_shell.dart';

class AppRouter {
  AppRouter._();

  // Route paths
  static const String home = '/home';
  static const String products = '/products';
  static const String addProduct = '/products/add';
  static const String editProduct = '/products/edit';
  static const String calculator = '/calculator';
  static const String calculationResults = '/calculator/results';
  static const String settings = '/settings';

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: products,
    routes: [
      // ── Shell Route (Bottom Navigation) ──
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: home,
            pageBuilder: (context, state) => const NoTransitionPage(child: HomePage()),
          ),
          GoRoute(
            path: products,
            pageBuilder: (context, state) => NoTransitionPage(
              child: BlocProvider(
                create: (_) => sl<ProductListCubit>()..loadProducts(),
                child: const ManageProductsPage(),
              ),
            ),
          ),
          GoRoute(
            path: calculator,
            pageBuilder: (context, state) => NoTransitionPage(
              child: BlocProvider(
                create: (_) => sl<OrderCalculatorCubit>()..loadProducts(),
                child: const CalculateOrderPage(),
              ),
            ),
          ),
          GoRoute(
            path: settings,
            pageBuilder: (context, state) => NoTransitionPage(
              child: _PlaceholderPage(title: AppStrings.navSettings, icon: Icons.settings_rounded),
            ),
          ),
        ],
      ),

      // ── Full-screen routes (outside shell) ──
      GoRoute(
        path: addProduct,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<ProductFormCubit>()..initForm(null),
          child: const AddEditProductPage(),
        ),
      ),
      GoRoute(
        path: editProduct,
        builder: (context, state) {
          final product = state.extra as Product;
          return BlocProvider(
            create: (_) => sl<ProductFormCubit>()..initForm(product),
            child: const AddEditProductPage(),
          );
        },
      ),
      GoRoute(
        path: calculationResults,
        builder: (context, state) {
          final result = state.extra as CalculationResult;
          return BlocProvider(
            create: (_) => CalculationResultCubit(result),
            child: const CalculationResultsPage(),
          );
        },
      ),
    ],
  );
}

/// Placeholder page for tabs without content yet.
class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: AppColors.primary.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text('قريبًا...', style: TextStyle(fontSize: 14, color: AppColors.textTertiary)),
          ],
        ),
      ),
    );
  }
}
