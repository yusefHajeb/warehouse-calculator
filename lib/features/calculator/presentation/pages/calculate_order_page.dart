import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../widgets/calculation_header.dart';
import '../widgets/product_selector.dart';
import '../widgets/carton_quantity_input.dart';
import '../widgets/calculate_button.dart';

class CalculateOrderPage extends StatelessWidget {
  const CalculateOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: CalculationHeader(),
            ),

            // Scrollable body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: const [
                    ProductSelector(),
                    SizedBox(height: 32),
                    CartonQuantityInput(),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ── Bulk order entry
            const Padding(padding: EdgeInsets.symmetric(horizontal: 24), child: _BulkOrderButton()),
            const SizedBox(height: 16),

            const SizedBox(height: 8),

            // Bottom button
            const CalculateButton(),
          ],
        ),
      ),
    );
  }
}

class _BulkOrderButton extends StatelessWidget {
  const _BulkOrderButton();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => context.push(AppRouter.bulkOrder),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDarkAlt : const Color(0xFFF0F7FF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark
                ? AppColors.primary.withValues(alpha: 0.3)
                : AppColors.primary.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.playlist_add_rounded, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'بناء طلب مجمع',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'احسب مواد عدة منتجات دفعةً واحدة',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.textDarkTertiary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_back_ios_rounded,
              size: 14,
              color: isDark ? AppColors.textDarkTertiary : AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
