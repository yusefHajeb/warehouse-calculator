import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

/// A single ingredient row with name input, weight input, and delete button.
///
/// This is a static presentation-only widget.
/// Logic (controllers, callbacks) will be wired in Phase 2.
class IngredientRow extends StatelessWidget {
  const IngredientRow({super.key, this.nameValue, this.weightValue});

  final String? nameValue;
  final String? weightValue;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Ingredient name ──
        Expanded(
          child: TextFormField(
            initialValue: nameValue,
            decoration: InputDecoration(
              hintText: AppStrings.ingredientNameHint,
              filled: true,
              fillColor: isDark ? AppColors.inputDark : AppColors.surfaceLight,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: isDark ? AppColors.ringDark : AppColors.ringLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: isDark ? AppColors.ringDark : AppColors.ringLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
            ),
          ),
        ),

        const SizedBox(width: 12),

        // ── Weight input ──
        SizedBox(
          width: 96,
          child: TextFormField(
            initialValue: weightValue,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
            decoration: InputDecoration(
              hintText: AppStrings.weightHint,
              filled: true,
              fillColor: isDark ? AppColors.inputDark : AppColors.surfaceLight,
              contentPadding: const EdgeInsets.only(right: 12, left: 28, top: 14, bottom: 14),
              suffixIcon: const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Text(
                  AppStrings.gramSymbol,
                  style: TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: isDark ? AppColors.ringDark : AppColors.ringLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: isDark ? AppColors.ringDark : AppColors.ringLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
            ),
          ),
        ),

        const SizedBox(width: 4),

        // ── Delete button ──
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: IconButton(
            onPressed: () {
              // TODO: Wire delete logic in Phase 2
            },
            icon: const Icon(Icons.remove_circle_outline_rounded),
            color: AppColors.textTertiary,
            splashRadius: 20,
            tooltip: AppStrings.delete,
          ),
        ),
      ],
    );
  }
}
