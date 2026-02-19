import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/calculation_result.dart';
import '../cubit/calulation_result_cubit/calculation_result_cubit.dart';

class RawMaterialsTable extends StatelessWidget {
  const RawMaterialsTable({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<CalculationResultCubit, CalculationResult>(
      builder: (context, state) {
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
                  Divider(
                    height: 1,
                    color: isDark ? AppColors.borderDark : const Color(0xFFF1F5F9),
                  ),

                  // Dynamic rows
                  for (var i = 0; i < state.materials.length; i++) ...[
                    _TableRow(material: state.materials[i]),
                    if (i < state.materials.length - 1)
                      Divider(
                        height: 1,
                        color: isDark ? AppColors.borderDark : const Color(0xFFF1F5F9),
                      ),
                  ],

                  // Footer divider
                  Divider(
                    height: 1,
                    color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
                  ),

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
                            '${state.totalWeightKg.toStringAsFixed(2)} كجم',
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
      },
    );
  }
}

class _TableRow extends StatelessWidget {
  const _TableRow({required this.material});

  final MaterialRequirement material;

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
              material.ingredientName,
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
              material.perPieceGrams.toStringAsFixed(2),
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
              '${material.requiredKg.toStringAsFixed(2)} كجم',
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
