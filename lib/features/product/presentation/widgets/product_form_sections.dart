import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

class BasicInfoSection extends StatelessWidget {
  const BasicInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(text: AppStrings.basicInfoSection),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: _sectionBoxDecoration(isDark),
          child: Column(
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
                decoration: InputDecoration(
                  hintText: AppStrings.productNameHint,
                  filled: true,
                  fillColor: isDark ? AppColors.inputDark : AppColors.surfaceLight,
                ),
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Packaging structure section with pieces/box and boxes/carton inputs.
class PackagingSection extends StatelessWidget {
  const PackagingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(text: AppStrings.packagingSection),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: _sectionBoxDecoration(isDark),
          child: Column(
            children: [
              // Two-column row
              Row(
                children: [
                  Expanded(
                    child: _PackagingField(
                      label: AppStrings.piecesPerBox,
                      icon: Icons.layers_rounded,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _PackagingField(
                      label: AppStrings.boxesPerCarton,
                      icon: Icons.inventory_2_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Info note
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
                          color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
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

/// Sticky save button at the bottom of the Add/Edit Product page.
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
        child: ElevatedButton(
          onPressed: () {
            // TODO: Wire save logic in Phase 2
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 4,
            shadowColor: AppColors.primary.withValues(alpha: 0.20),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          child: const Text(AppStrings.saveProduct),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SHARED PRIVATE HELPERS
// ═══════════════════════════════════════════════════════════════

/// Reusable section header label used across form sections.
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

/// Reusable packaging field with label and numeric input.
class _PackagingField extends StatelessWidget {
  const _PackagingField({required this.label, required this.icon});

  final String label;
  final IconData icon;

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
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: '0',
            filled: true,
            fillColor: isDark ? AppColors.inputDark : AppColors.surfaceLight,
            prefixIcon: Icon(icon, size: 20, color: AppColors.textTertiary),
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
