import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/calculation_header.dart';
import '../widgets/product_selector.dart';
import '../widgets/carton_quantity_input.dart';
import '../widgets/calculation_info_banner.dart';
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
                    SizedBox(height: 32),
                    CalculationInfoBanner(),
                  ],
                ),
              ),
            ),

            // Bottom button
            const CalculateButton(),
          ],
        ),
      ),
    );
  }
}
