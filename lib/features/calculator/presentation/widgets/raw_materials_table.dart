import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

class RawMaterialsTable extends StatelessWidget {
  const RawMaterialsTable({super.key});

  // Static demo data
  static const _rows = [
    _IngredientData('دقيق (نوع 00)', '15.50', '193.75'),
    _IngredientData('سكر أبيض', '8.25', '103.12'),
    _IngredientData('زبدة (غير مملحة)', '12.00', '150.00'),
    _IngredientData('مسحوق اللوز', '5.50', '68.75'),
    _IngredientData('خلاصة الفانيليا', '0.50', '6.25'),
    _IngredientData('ملح', '0.10', '1.25'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Section header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.resultsRawMaterials,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: () {
                // TODO: Edit inputs in Phase 2
              },
              child: Text(
                AppStrings.resultsEditInputs,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Table card
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDarkAlt : Colors.white,
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
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              // Table header
              Container(
                color: isDark
                    ? AppColors.surfaceDarkAlt.withValues(alpha: 0.5)
                    : const Color(0xFFF8FAFC),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        AppStrings.resultsIngredientCol,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          color: isDark ? AppColors.textDarkTertiary : AppColors.textSecondary,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        AppStrings.resultsPerPieceCol,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          color: isDark ? AppColors.textDarkTertiary : AppColors.textSecondary,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        AppStrings.resultsRequiredCol,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          color: isDark ? AppColors.textDarkTertiary : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Divider
              Divider(height: 1, color: isDark ? AppColors.borderDark : const Color(0xFFF1F5F9)),

              // Rows
              for (final row in _rows) ...[
                _TableRow(data: row),
                if (row != _rows.last)
                  Divider(
                    height: 1,
                    color: isDark ? AppColors.borderDark : const Color(0xFFF1F5F9),
                  ),
              ],

              // Footer divider
              Divider(height: 1, color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),

              // Footer
              Container(
                color: isDark
                    ? AppColors.backgroundDark.withValues(alpha: 0.5)
                    : const Color(0xFFF8FAFC),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        AppStrings.resultsTotalWeight,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const Expanded(flex: 2, child: SizedBox.shrink()),
                    Expanded(
                      flex: 3,
                      child: Text(
                        '523.12 كجم',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _IngredientData {
  const _IngredientData(this.name, this.perPiece, this.required);
  final String name;
  final String perPiece;
  final String required;
}

class _TableRow extends StatelessWidget {
  const _TableRow({required this.data});

  final _IngredientData data;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              data.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              data.perPiece,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppColors.textDarkSecondary : const Color(0xFF475569),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              data.required,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? const Color(0xFF60A5FA) : AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
