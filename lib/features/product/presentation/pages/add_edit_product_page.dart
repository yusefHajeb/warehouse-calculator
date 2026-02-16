import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/add_edit_product_header.dart';
import '../widgets/product_form_sections.dart';
import '../widgets/ingredient_row.dart';

/// Add / Edit Product page — static presentation only.
///
/// Mirrors the HTML design: header with Cancel/Save,
/// scrollable body with Basic Info, Packaging Structure, Ingredients sections,
/// and a sticky "Save Product" button at the bottom.
class AddEditProductPage extends StatelessWidget {
  const AddEditProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // ── Header ──
                const AddEditProductHeader(),

                // ── Body ──
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: const [
                          BasicInfoSection(),
                          SizedBox(height: 24),
                          PackagingSection(),
                          SizedBox(height: 24),
                          _IngredientsWithRows(),
                          SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ── Sticky bottom button ──
            const SaveProductButton(),
          ],
        ),
      ),
    );
  }
}

/// Composes the IngredientsSection header/button with IngredientRow widgets.
///
/// Kept here because it combines widgets from two sibling files
/// (product_form_sections.dart and ingredient_row.dart).
class _IngredientsWithRows extends StatelessWidget {
  const _IngredientsWithRows();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'المكونات',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: isDark ? AppColors.textDarkTertiary : AppColors.textTertiary,
                ),
              ),
              Text(
                'الكمية لكل قطعة (جرام)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textDarkTertiary : AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Ingredient rows (static demo data)
        const IngredientRow(nameValue: 'دقيق', weightValue: '15.5'),
        const SizedBox(height: 12),
        const IngredientRow(nameValue: 'سكر', weightValue: '8.0'),
        const SizedBox(height: 12),
        const IngredientRow(),

        const SizedBox(height: 16),

        // "Add Ingredient" button
        OutlinedButton.icon(
          onPressed: () {
            // TODO: Wire add-ingredient logic in Phase 2
          },
          icon: const Icon(Icons.add_rounded, size: 20),
          label: const Text('إضافة مكون', style: TextStyle(fontWeight: FontWeight.w500)),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: BorderSide(
              color: AppColors.primary.withValues(alpha: isDark ? 0.4 : 0.3),
              width: 2,
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            minimumSize: const Size.fromHeight(48),
          ),
        ),
      ],
    );
  }
}
