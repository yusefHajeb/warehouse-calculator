import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';

class StockWarningBanner extends StatelessWidget {
  const StockWarningBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF7C2D12).withValues(alpha: 0.20) : const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? const Color(0xFF7C2D12).withValues(alpha: 0.50) : const Color(0xFFFFEDD5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_rounded, color: Color(0xFFF97316), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.resultsStockWarningTitle,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFFFED7AA) : const Color(0xFF9A3412),
                  ),
                ),
                const SizedBox(height: 4),
                Text.rich(
                  TextSpan(
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.6,
                      color: isDark ? const Color(0xFFFED7AA) : const Color(0xFF9A3412),
                    ),
                    children: [
                      const TextSpan(text: 'المخزون الحالي من '),
                      TextSpan(
                        text: 'زبدة (غير مملحة)',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const TextSpan(text: ' أقل من الكمية المطلوبة (المتوفر 120.00 كجم فقط).'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
