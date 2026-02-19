import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../router/app_router.dart';

/// Main application shell with a bottom navigation bar.
///
/// Uses GoRouter's ShellRoute — receives `child` from the router
/// and displays it inside the body with a persistent bottom nav.
class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  static int _calculateIndex(String location) {
    if (location.startsWith(AppRouter.home)) return 0;
    if (location.startsWith(AppRouter.products)) return 1;
    if (location.startsWith(AppRouter.calculator)) return 2;
    if (location.startsWith(AppRouter.settings)) return 3;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _calculateIndex(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.backgroundDark : AppColors.surfaceLight,
          border: Border(
            top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.ringLight),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _navItem(
                  context: context,
                  icon: Icons.home_rounded,
                  label: AppStrings.navHome,
                  path: AppRouter.home,
                  isSelected: currentIndex == 0,
                  isDark: isDark,
                ),
                _navItem(
                  context: context,
                  icon: Icons.inventory_rounded,
                  label: AppStrings.navProducts,
                  path: AppRouter.products,
                  isSelected: currentIndex == 1,
                  isDark: isDark,
                ),
                _navItem(
                  context: context,
                  icon: Icons.calculate_rounded,
                  label: AppStrings.navCalculator,
                  path: AppRouter.calculator,
                  isSelected: currentIndex == 2,
                  isDark: isDark,
                ),
                _navItem(
                  context: context,
                  icon: Icons.settings_rounded,
                  label: AppStrings.navSettings,
                  path: AppRouter.settings,
                  isSelected: currentIndex == 3,
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String path,
    required bool isSelected,
    required bool isDark,
  }) {
    final color = isSelected
        ? AppColors.primary
        : (isDark ? AppColors.textDarkSecondary : AppColors.textTertiary);

    return GestureDetector(
      onTap: () => context.go(path),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
