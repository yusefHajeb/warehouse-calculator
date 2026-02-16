import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/results_header.dart';
import '../widgets/product_info_section.dart';
import '../widgets/production_summary_card.dart';
import '../widgets/raw_materials_table.dart';
import '../widgets/stock_warning_banner.dart';
import '../widgets/results_bottom_actions.dart';

class CalculationResultsPage extends StatelessWidget {
  const CalculationResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            const Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: ResultsHeader()),

            // Scrollable body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 140),
                child: Column(
                  children: const [
                    ProductInfoSection(),
                    SizedBox(height: 24),
                    ProductionSummaryCard(),
                    SizedBox(height: 24),
                    RawMaterialsTable(),
                    SizedBox(height: 24),
                    StockWarningBanner(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom actions (positioned absolutely over content)
      bottomNavigationBar: const ResultsBottomActions(),
    );
  }
}
