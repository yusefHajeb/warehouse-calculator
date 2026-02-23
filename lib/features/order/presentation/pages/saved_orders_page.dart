import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../cubit/order_list_cubit.dart';

class SavedOrdersPage extends StatelessWidget {
  const SavedOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.backgroundDark : Colors.white,
                border: Border(
                  bottom: BorderSide(color: isDark ? AppColors.borderDark : AppColors.ringLight),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.receipt_long_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الطلبات المحفوظة',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'إدارة الطلبات وتصدير PDF',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.textDarkTertiary : AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── List
            Expanded(
              child: BlocBuilder<OrderListCubit, OrderListState>(
                builder: (context, state) {
                  if (state.status == OrderListStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.orders.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_rounded,
                            size: 64,
                            color: AppColors.primary.withValues(alpha: 0.2),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'لا توجد طلبات محفوظة',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'احسب طلبًا مجمعًا ثم اضغط "حفظ الطلب"',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? AppColors.textDarkTertiary : AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => context.read<OrderListCubit>().loadOrders(),
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.orders.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final order = state.orders[index];
                        return Dismissible(
                          key: ValueKey(order.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 24),
                            decoration: BoxDecoration(
                              color: AppColors.danger,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.delete_rounded, color: Colors.white),
                          ),
                          confirmDismiss: (_) async {
                            return await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('حذف الطلب'),
                                content: Text('هل تريد حذف "${order.name}"؟'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text('إلغاء'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: const Text(
                                      'حذف',
                                      style: TextStyle(color: AppColors.danger),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          onDismissed: (_) => context.read<OrderListCubit>().deleteOrder(order.id),
                          child: GestureDetector(
                            onTap: () => context.push('${AppRouter.orders}/${order.id}'),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.surfaceDark : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isDark ? AppColors.borderDark : AppColors.ringLight,
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Leading badge
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.receipt_rounded,
                                        color: AppColors.primary,
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),

                                  // Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          order.name,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: isDark
                                                ? AppColors.textDarkPrimary
                                                : AppColors.textPrimary,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${order.orderDate.year}/${order.orderDate.month.toString().padLeft(2, '0')}/${order.orderDate.day.toString().padLeft(2, '0')}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: isDark
                                                ? AppColors.textDarkTertiary
                                                : AppColors.textTertiary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Right side stats
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${_fmt(order.totalPieces)} قطعة',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${order.totalWeightKg.toStringAsFixed(1)} كجم',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isDark
                                              ? AppColors.textDarkTertiary
                                              : AppColors.textTertiary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.chevron_left_rounded,
                                    color: isDark
                                        ? AppColors.textDarkTertiary
                                        : AppColors.textTertiary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _fmt(int n) {
  final s = n.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return buf.toString();
}
