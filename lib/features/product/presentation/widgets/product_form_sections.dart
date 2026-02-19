import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../cubit/product_form_cubit.dart';
import '../cubit/product_form_state.dart';

/// Basic info section — product name field wired to Cubit.
class BasicInfoSection extends StatelessWidget {
  const BasicInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cubit = context.read<ProductFormCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(text: AppStrings.basicInfoSection),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: _sectionBoxDecoration(isDark),
          child: BlocBuilder<ProductFormCubit, ProductFormState>(
            buildWhen: (prev, curr) =>
                prev.product.name != curr.product.name ||
                prev.validationErrors['name'] != curr.validationErrors['name'],
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.productName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.textDarkSecondary
                          : AppColors.textSecondary.withValues(alpha: 0.85),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    initialValue: state.product.name,
                    onChanged: cubit.nameChanged,
                    decoration: InputDecoration(
                      hintText: AppStrings.productNameHint,
                      filled: true,
                      fillColor: isDark ? AppColors.inputDark : AppColors.surfaceLight,
                      errorText: state.validationErrors['name'],
                    ),
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Packaging section — pieces/box and boxes/carton wired to Cubit.
class PackagingSection extends StatelessWidget {
  const PackagingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cubit = context.read<ProductFormCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(text: AppStrings.packagingSection),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: _sectionBoxDecoration(isDark),
          child: BlocBuilder<ProductFormCubit, ProductFormState>(
            buildWhen: (prev, curr) =>
                prev.product.piecesPerBox != curr.product.piecesPerBox ||
                prev.product.boxesPerCarton != curr.product.boxesPerCarton ||
                prev.validationErrors['piecesPerBox'] != curr.validationErrors['piecesPerBox'] ||
                prev.validationErrors['boxesPerCarton'] != curr.validationErrors['boxesPerCarton'],
            builder: (context, state) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _PackagingField(
                          label: AppStrings.piecesPerBox,
                          icon: Icons.layers_rounded,
                          initialValue: state.product.piecesPerBox > 0
                              ? state.product.piecesPerBox.toString()
                              : '',
                          onChanged: cubit.piecesPerBoxChanged,
                          errorText: state.validationErrors['piecesPerBox'],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _PackagingField(
                          label: AppStrings.boxesPerCarton,
                          icon: Icons.inventory_2_rounded,
                          initialValue: state.product.boxesPerCarton > 0
                              ? state.product.boxesPerCarton.toString()
                              : '',
                          onChanged: cubit.boxesPerCartonChanged,
                          errorText: state.validationErrors['boxesPerCarton'],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Computed total pieces
                  if (state.product.piecesPerBox > 0 && state.product.boxesPerCarton > 0)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.statusAvailableBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            size: 16,
                            color: AppColors.statusAvailableText,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'إجمالي القطع في الكرتونة: ${state.product.piecesPerCarton}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.statusAvailableText,
                            ),
                          ),
                        ],
                      ),
                    ),

                  if (state.product.piecesPerBox <= 0 || state.product.boxesPerCarton <= 0)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: isDark ? 0.10 : 0.05),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_rounded, size: 16, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              AppStrings.packagingInfoNote,
                              style: TextStyle(
                                fontSize: 12,
                                height: 1.6,
                                color: isDark
                                    ? AppColors.textDarkSecondary
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Sticky save button — wired to Cubit.
class SaveProductButton extends StatelessWidget {
  const SaveProductButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: (isDark ? AppColors.surfaceDark : AppColors.surfaceLight).withValues(alpha: 0.9),
          border: Border(
            top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
        ),
        child: BlocBuilder<ProductFormCubit, ProductFormState>(
          buildWhen: (prev, curr) => prev.status != curr.status,
          builder: (context, state) {
            final isSubmitting = state.status == ProductFormStatus.submitting;

            return ElevatedButton(
              onPressed: isSubmitting ? null : () => context.read<ProductFormCubit>().saveProduct(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
                elevation: 4,
                shadowColor: AppColors.primary.withValues(alpha: 0.20),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              child: isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text(AppStrings.saveProduct),
            );
          },
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SHARED PRIVATE HELPERS
// ═══════════════════════════════════════════════════════════════

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: isDark ? AppColors.textDarkTertiary : AppColors.textTertiary,
      ),
    );
  }
}

class _PackagingField extends StatelessWidget {
  const _PackagingField({
    required this.label,
    required this.icon,
    required this.onChanged,
    this.initialValue,
    this.errorText,
  });

  final String label;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final String? initialValue;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark
                ? AppColors.textDarkSecondary
                : AppColors.textSecondary.withValues(alpha: 0.85),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: initialValue,
          keyboardType: TextInputType.number,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: '0',
            filled: true,
            fillColor: isDark ? AppColors.inputDark : AppColors.surfaceLight,
            prefixIcon: Icon(icon, size: 20, color: AppColors.textTertiary),
            errorText: errorText,
          ),
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

BoxDecoration _sectionBoxDecoration(bool isDark) {
  return BoxDecoration(
    color: isDark ? AppColors.backgroundDark.withValues(alpha: 0.5) : AppColors.backgroundLight,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
  );
}
