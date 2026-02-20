import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/calculation_result.dart';

class BulkOrderItemCard extends StatelessWidget {
  final BulkOrderItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const BulkOrderItemCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.ringLight),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: name + actions
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.product.name,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${item.product.piecesPerBox} قطعة/صندوق · ${item.product.boxesPerCarton} صندوق/كرتون',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.textDarkTertiary : AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Edit button
                _ActionButton(
                  icon: Icons.edit_rounded,
                  color: const Color(0xFF2563EB), // blue-600
                  bgColor: const Color(0xFFEFF6FF), // blue-50
                  bgColorDark: const Color(0x3393C5FD), // blue-900/20
                  onTap: onEdit,
                  isDark: isDark,
                ),
                const SizedBox(width: 4),
                // Delete button
                _ActionButton(
                  icon: Icons.delete_rounded,
                  color: AppColors.danger,
                  bgColor: const Color(0xFFFEF2F2), // red-50
                  bgColorDark: const Color(0x33FCA5A5), // red-900/20
                  onTap: onDelete,
                  isDark: isDark,
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Info strip
            Container(
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surfaceDarkAlt.withValues(alpha: 0.5)
                    : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Left column: cartons
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'الكمية (كرتون)',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? AppColors.textDarkTertiary : AppColors.textTertiary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatNumber(item.cartonCount),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Divider
                  Container(
                    width: 1,
                    height: 36,
                    color: isDark ? AppColors.borderDark : AppColors.ringLight,
                  ),

                  // Right column: total pieces
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'إجمالي القطع',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? AppColors.textDarkTertiary : AppColors.textTertiary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatNumber(item.totalPieces),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bgColor;
  final Color bgColorDark;
  final VoidCallback onTap;
  final bool isDark;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.bgColorDark,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDark ? bgColorDark : bgColor,
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

String _formatNumber(int n) {
  final s = n.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return buf.toString();
}
