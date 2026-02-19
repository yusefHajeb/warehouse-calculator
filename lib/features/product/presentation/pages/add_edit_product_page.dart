import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../cubit/product_form_cubit.dart';
import '../cubit/product_form_state.dart';
import '../widgets/add_edit_product_header.dart';
import '../widgets/product_form_sections.dart';
import '../widgets/ingredient_row.dart';

class AddEditProductPage extends StatelessWidget {
  const AddEditProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<ProductFormCubit, ProductFormState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == ProductFormStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.isEditing ? 'تم تحديث المنتج بنجاح' : 'تم إضافة المنتج بنجاح'),
              backgroundColor: AppColors.statusAvailableText,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          );
          context.pop();
        } else if (state.status == ProductFormStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'حدث خطأ'),
              backgroundColor: AppColors.danger,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  const AddEditProductHeader(),
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
              const SaveProductButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _IngredientsWithRows extends StatelessWidget {
  const _IngredientsWithRows();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cubit = context.read<ProductFormCubit>();

    return BlocBuilder<ProductFormCubit, ProductFormState>(
      // buildWhen: (prev, curr) =>
      //     prev.product.ingredients != curr.product.ingredients ||
      //     prev.validationErrors != curr.validationErrors,
      builder: (context, state) {
        final ingredients = state.product.ingredients;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

            if (state.validationErrors.containsKey('ingredients'))
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  state.validationErrors['ingredients']!,
                  style: const TextStyle(fontSize: 12, color: AppColors.danger),
                ),
              ),

            ...List.generate(ingredients.length, (index) {
              return Padding(
                key: ValueKey(ingredients[index].id),
                padding: EdgeInsets.only(bottom: index < ingredients.length - 1 ? 12 : 0),
                child: IngredientRow(
                  nameValue: ingredients[index].name,
                  weightValue: ingredients[index].quantityPerPiece > 0
                      ? ingredients[index].quantityPerPiece.toString()
                      : '',
                  nameError: state.validationErrors['ingredient_${index}_name'],
                  quantityError: state.validationErrors['ingredient_${index}_quantity'],
                  onNameChanged: (name) => cubit.updateIngredientName(index, name),
                  onWeightChanged: (value) => cubit.updateIngredientQuantity(index, value),
                  onDelete: () => cubit.removeIngredient(index, ingredients[index].id),
                ),
              );
            }),

            const SizedBox(height: 16),

            OutlinedButton.icon(
              onPressed: () => cubit.addIngredient(),
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
      },
    );
  }
}
