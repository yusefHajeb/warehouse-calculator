import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/product/presentation/pages/manage_products_page.dart';
import '../../features/calculator/presentation/pages/calculate_order_page.dart';

/// Main application shell with a bottom navigation bar.
///
/// Holds the four tabs: Home, Products, Calculator, Settings.
/// Only the Products tab has content for now; others are placeholders.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 1; // Start on Products tab

  // Pages for each tab – placeholders until HTML is provided
  final List<Widget> _pages = [
    const HomePage(),
    const ManageProductsPage(),
    const CalculateOrderPage(),
    const _PlaceholderPage(title: AppStrings.navSettings, icon: Icons.settings_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
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
                  icon: Icons.home_rounded,
                  label: AppStrings.navHome,
                  index: 0,
                  isDark: isDark,
                ),
                _navItem(
                  icon: Icons.inventory_rounded,
                  label: AppStrings.navProducts,
                  index: 1,
                  isDark: isDark,
                ),
                _navItem(
                  icon: Icons.calculate_rounded,
                  label: AppStrings.navCalculator,
                  index: 2,
                  isDark: isDark,
                ),
                _navItem(
                  icon: Icons.settings_rounded,
                  label: AppStrings.navSettings,
                  index: 3,
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
    required IconData icon,
    required String label,
    required int index,
    required bool isDark,
  }) {
    final isSelected = _currentIndex == index;
    final color = isSelected
        ? AppColors.primary
        : (isDark ? AppColors.textDarkSecondary : AppColors.textTertiary);

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
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

/// Placeholder page for tabs without content yet.
class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: AppColors.primary.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text('قريبًا...', style: TextStyle(fontSize: 14, color: AppColors.textTertiary)),
          ],
        ),
      ),
    );
  }
}
