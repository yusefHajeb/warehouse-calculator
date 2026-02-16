import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

class ProductSelector extends StatelessWidget {
  const ProductSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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

        Container(
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.surfaceDarkAlt.withValues(alpha: 0.5)
                : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
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
              // Search icon (right side / suffix in RTL)
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.search_rounded,
                  color: isDark ? AppColors.textDarkTertiary : AppColors.textTertiary,
                ),
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDarkAlt : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
                    ),
                    boxShadow: isDark
                        ? null
                        : [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 2)],
                  ),
                  child: Icon(
                    Icons.qr_code_scanner_rounded,
                    size: 20,
                    color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary,
                  ),
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

        // Recent choices
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Text(
            AppStrings.calcRecentChoices,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.textDarkTertiary : AppColors.textTertiary,
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Chips row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: const [
              _RecentChip(label: 'كولا ١٢ عبوة', dotColor: Color(0xFF22C55E)),
              SizedBox(width: 8),
              _RecentChip(label: 'عصير برتقال ١ لتر', dotColor: Color(0xFFF97316)),
              SizedBox(width: 8),
              _RecentChip(label: 'مياه ٥٠٠ مل', dotColor: Color(0xFF3B82F6)),
            ],
          ),
        ),
      ],
    );
  }
}

class _RecentChip extends StatelessWidget {
  const _RecentChip({required this.label, required this.dotColor});

  final String label;
  final Color dotColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: isDark ? AppColors.surfaceDarkAlt : Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () {
          // TODO: Select product in Phase 2
        },
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
                decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(
                label,
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
