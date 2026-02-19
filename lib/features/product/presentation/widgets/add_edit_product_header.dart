import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../cubit/product_form_cubit.dart';
import '../cubit/product_form_state.dart';

class AddEditProductHeader extends StatelessWidget {
  const AddEditProductHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        border: Border(
          bottom: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
      ),
      child: BlocBuilder<ProductFormCubit, ProductFormState>(
        buildWhen: (prev, curr) => prev.isEditing != curr.isEditing || prev.status != curr.status,
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Text(
                  AppStrings.cancel,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
                  ),
                ),
              ),
              Text(
                state.isEditing ? 'تعديل المنتج' : 'إضافة منتج جديد',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: state.status == ProductFormStatus.submitting
                    ? null
                    : () => context.read<ProductFormCubit>().saveProduct(),
                child: Text(
                  AppStrings.save,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: state.status == ProductFormStatus.submitting
                        ? AppColors.primary.withValues(alpha: 0.4)
                        : AppColors.primary,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
