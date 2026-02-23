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
import '../../features/calculator/presentation/pages/bulk_order_page.dart';
import '../../features/calculator/presentation/pages/bulk_results_page.dart';
import '../../features/calculator/presentation/cubit/order_calculator_cubit/order_calculator_cubit.dart';
import '../../features/calculator/presentation/cubit/calulation_result_cubit/calculation_result_cubit.dart';
import '../../features/calculator/presentation/cubit/bulk_order_cubit/bulk_order_cubit.dart';
import '../../features/calculator/presentation/cubit/bulk_result_cubit/bulk_result_cubit.dart';
import '../../features/calculator/domain/entities/calculation_result.dart';
import '../../features/order/presentation/cubit/order_list_cubit.dart';
import '../../features/order/presentation/cubit/order_detail_cubit.dart';
import '../../features/order/presentation/pages/saved_orders_page.dart';
import '../../features/order/presentation/pages/order_detail_page.dart';
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
  static const String bulkOrder = '/calculator/bulk';
  static const String bulkOrderResults = '/calculator/bulk/results';
  static const String orders = '/orders';
  static const String orderDetail = '/orders/detail';

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
            path: orders,
            pageBuilder: (context, state) => NoTransitionPage(
              child: BlocProvider(
                create: (_) => sl<OrderListCubit>()..loadOrders(),
                child: const SavedOrdersPage(),
              ),
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
      GoRoute(
        path: bulkOrder,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<BulkOrderCubit>()..loadProducts(),
          child: const BulkOrderPage(),
        ),
      ),
      GoRoute(
        path: bulkOrderResults,
        builder: (context, state) {
          final result = state.extra as BulkCalculationResult;
          return BlocProvider(
            create: (_) => BulkResultCubit(result),
            child: const BulkResultsPage(),
          );
        },
      ),
      // ── Order detail (`/orders/detail` with orderId in extra) ──
      GoRoute(
        path: '$orders/:orderId',
        builder: (context, state) {
          final orderId = state.pathParameters['orderId']!;
          return BlocProvider(
            create: (_) => sl<OrderDetailCubit>()..load(orderId),
            child: const OrderDetailPage(),
          );
        },
      ),
    ],
  );
}
