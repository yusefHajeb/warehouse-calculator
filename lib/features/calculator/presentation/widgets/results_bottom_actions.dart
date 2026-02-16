import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

class ResultsBottomActions extends StatelessWidget {
  const ResultsBottomActions({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        border: Border(
          top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
      ),
      child: Row(
        children: [
          // PDF button (outlined)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: Export PDF in Phase 2
              },
              icon: const Icon(Icons.picture_as_pdf_rounded, size: 20),
              label: const Text(AppStrings.resultsExportPdf),
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark ? AppColors.textDarkPrimary : const Color(0xFF334155),
                side: BorderSide(color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Print button (filled primary)
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Print in Phase 2
              },
              icon: const Icon(Icons.print_rounded, size: 20),
              label: const Text(AppStrings.resultsPrint),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 8,
                shadowColor: AppColors.primary.withValues(alpha: 0.25),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
