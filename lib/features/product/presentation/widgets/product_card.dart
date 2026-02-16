import 'package:flutter/material.dart';
import 'package:product_management/features/product/presentation/pages/add_edit_product_page.dart';
import '../../../../core/constants/app_colors.dart';

/// Status types for product cards.
enum ProductStatus { available, lowStock, archived, none }

/// A single product card matching the HTML design.
///
/// Shows product name, optional status badge, packaging info,
/// item number, last update, and edit/delete action buttons.
/// Static presentation only — logic wired in Phase 2.
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.name,
    required this.packagingInfo,
    required this.itemCode,
    required this.lastUpdate,
    this.status = ProductStatus.none,
    this.isArchived = false,
  });

  final String name;
  final String packagingInfo;
  final String itemCode;
  final String lastUpdate;
  final ProductStatus status;
  final bool isArchived;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Opacity(
      opacity: isArchived ? 0.6 : 1.0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Content ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + badge
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (status != ProductStatus.none) ...[
                        const SizedBox(width: 8),
                        _buildBadge(isDark),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Packaging info
                  Row(
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 16, color: AppColors.textTertiary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          packagingInfo,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Item number + last update
                  Row(
                    children: [
                      Text(
                        'رقم الصنف: $itemCode',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'آخر تحديث: $lastUpdate',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // ── Action buttons ──
            Column(
              children: [
                _actionButton(
                  icon: Icons.edit_outlined,
                  color: AppColors.primary,
                  isDark: isDark,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddEditProductPage()),
                    );
                    // TODO: Navigate to edit in Phase 2
                  },
                ),
                const SizedBox(height: 8),
                _actionButton(
                  icon: Icons.delete_outline_rounded,
                  color: AppColors.danger,
                  isDark: isDark,
                  onTap: () {
                    // TODO: Delete logic in Phase 2
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(bool isDark) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case ProductStatus.available:
        bgColor = isDark ? AppColors.statusAvailableBgDark : AppColors.statusAvailableBg;
        textColor = isDark ? AppColors.statusAvailableTextDark : AppColors.statusAvailableText;
        label = 'متوفر';
      case ProductStatus.lowStock:
        bgColor = isDark ? AppColors.statusLowStockBgDark : AppColors.statusLowStockBg;
        textColor = isDark ? AppColors.statusLowStockTextDark : AppColors.statusLowStockText;
        label = 'مخزون منخفض';
      case ProductStatus.archived:
        bgColor = isDark ? AppColors.statusArchivedBgDark : AppColors.statusArchivedBg;
        textColor = isDark ? AppColors.statusArchivedTextDark : AppColors.statusArchivedText;
        label = 'مؤرشف';
      case ProductStatus.none:
        return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(4)),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: textColor),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Material(
      color: isDark ? AppColors.iconBgDark : AppColors.iconBgLight,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 20, color: color),
        ),
      ),
    );
  }
}
