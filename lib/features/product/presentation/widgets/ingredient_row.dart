import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

class IngredientRow extends StatelessWidget {
  const IngredientRow({
    super.key,
    this.nameValue,
    this.weightValue,
    this.nameError,
    this.quantityError,
    this.onNameChanged,
    this.onWeightChanged,
    this.onDelete,
  });

  final String? nameValue;
  final String? weightValue;
  final String? nameError;
  final String? quantityError;
  final ValueChanged<String>? onNameChanged;
  final ValueChanged<String>? onWeightChanged;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ingredient name
            Expanded(
              child: TextFormField(
                initialValue: nameValue,
                onChanged: onNameChanged,
                decoration: InputDecoration(
                  hintText: AppStrings.ingredientNameHint,
                  filled: true,
                  fillColor: isDark ? AppColors.inputDark : AppColors.surfaceLight,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isDark ? AppColors.ringDark : AppColors.ringLight,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: nameError != null
                          ? AppColors.danger
                          : (isDark ? AppColors.ringDark : AppColors.ringLight),
                    ),
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

            // Weight input
            SizedBox(
              width: 96,
              child: TextFormField(
                initialValue: weightValue,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.left,
                textDirection: TextDirection.ltr,
                onChanged: onWeightChanged,
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
                    borderSide: BorderSide(
                      color: isDark ? AppColors.ringDark : AppColors.ringLight,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: quantityError != null
                          ? AppColors.danger
                          : (isDark ? AppColors.ringDark : AppColors.ringLight),
                    ),
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

            // Delete button
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.remove_circle_outline_rounded),
                color: AppColors.textTertiary,
                splashRadius: 20,
                tooltip: AppStrings.delete,
              ),
            ),
          ],
        ),

        // Error messages
        if (nameError != null || quantityError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              nameError ?? quantityError ?? '',
              style: const TextStyle(fontSize: 11, color: AppColors.danger),
            ),
          ),
      ],
    );
  }
}
