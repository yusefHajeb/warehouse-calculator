import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

/// Welcome card showing greeting, shift info, date, and summary stats.
class WelcomeCard extends StatelessWidget {
  const WelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDarkAlt : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.homeGreeting,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppStrings.homeShiftInfo,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Date
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    AppStrings.homeDateLabel,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppStrings.homeDate,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.textDarkSecondary : const Color(0xFF334155),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          Divider(
            color: isDark ? AppColors.ringDark.withValues(alpha: 0.5) : AppColors.borderLight,
            height: 1,
          ),

          const SizedBox(height: 16),


          Row(
            children: [
              _StatItem(
                label: AppStrings.homePendingOrders,
                value: '12',
                valueColor: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
              ),
              _StatDivider(isDark: isDark),
              _StatItem(
                label: AppStrings.homeProductivity,
                value: '94%',
                valueColor: AppColors.primary,
              ),
              _StatDivider(isDark: isDark),
              _StatItem(label: AppStrings.homeAlerts, value: '0', valueColor: AppColors.warning),
            ],
          ),
        ],
      ),
    );
  }
}

/// Single stat item inside the welcome card.
class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value, required this.valueColor});

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: AppColors.textTertiary)),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: valueColor),
          ),
        ],
      ),
    );
  }
}

/// Vertical divider between stat items.
class _StatDivider extends StatelessWidget {
  const _StatDivider({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36,
      color: isDark ? AppColors.ringDark.withValues(alpha: 0.5) : AppColors.borderLight,
    );
  }
}
