import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../product/domain/entities/product.dart';
import '../cubit/order_calculator_cubit/order_calculator_cubit.dart';
import '../cubit/order_calculator_cubit/order_calculator_state.dart';

class ProductSelector extends StatelessWidget {
  const ProductSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<OrderCalculatorCubit, OrderCalculatorState>(
      buildWhen: (prev, curr) =>
          prev.selectedProduct != curr.selectedProduct ||
          prev.filteredProducts != curr.filteredProducts ||
          prev.searchQuery != curr.searchQuery ||
          prev.status != curr.status,
      builder: (context, state) {
        final cubit = context.read<OrderCalculatorCubit>();
        final hasSelected = state.selectedProduct != null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Text(
                AppStrings.calcSelectProduct,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                  color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Selected product chip (if any)
            if (hasSelected) ...[
              _SelectedProductChip(
                product: state.selectedProduct!,
                onClear: () => cubit.clearProduct(),
                isDark: isDark,
              ),
              const SizedBox(height: 12),
            ],

            // Search field (shown when no product selected)
            if (!hasSelected) ...[
              Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.surfaceDarkAlt.withValues(alpha: 0.5)
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
                  ),
                  boxShadow: isDark
                      ? null
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                ),
                child: TextField(
                  textAlign: TextAlign.right,
                  onChanged: (query) => cubit.searchProducts(query),
                  decoration: InputDecoration(
                    hintText: AppStrings.calcSearchHint,
                    hintStyle: TextStyle(
                      color: isDark ? AppColors.textDarkTertiary : AppColors.textTertiary,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.primary, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(
                        Icons.search_rounded,
                        color: isDark ? AppColors.textDarkTertiary : AppColors.textTertiary,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Product list / search results
              if (state.status == OrderCalculatorStatus.loading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                )
              else if (state.filteredProducts.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      state.searchQuery.isNotEmpty ? 'لا توجد نتائج' : 'لا توجد منتجات',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? AppColors.textDarkTertiary : AppColors.textTertiary,
                      ),
                    ),
                  ),
                )
              else
                // Show product chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: state.filteredProducts
                        .take(5)
                        .map(
                          (product) => Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: _ProductChip(
                              product: product,
                              onTap: () => cubit.selectProduct(product),
                              isDark: isDark,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
            ],
          ],
        );
      },
    );
  }
}

class _SelectedProductChip extends StatelessWidget {
  final Product product;
  final VoidCallback onClear;
  final bool isDark;

  const _SelectedProductChip({required this.product, required this.onClear, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.inventory_2_rounded, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${product.piecesPerBox} قطعة/صندوق • ${product.boxesPerCarton} صندوق/كرتون',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.textDarkTertiary : AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onClear,
            child: Icon(
              Icons.close_rounded,
              size: 20,
              color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductChip extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final bool isDark;

  const _ProductChip({required this.product, required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDark ? AppColors.surfaceDarkAlt : Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isDark ? AppColors.borderDark : const Color(0xFFF1F5F9)),
            boxShadow: isDark
                ? null
                : [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 2)],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(
                product.name,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textDarkSecondary : const Color(0xFF334155),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
