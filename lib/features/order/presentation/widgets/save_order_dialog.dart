import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../cubit/save_order_cubit.dart';


class SaveOrderDialog extends StatelessWidget {
  const SaveOrderDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          BlocProvider.value(value: context.read<SaveOrderCubit>(), child: const SaveOrderDialog()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomInsets = MediaQuery.of(context).viewInsets.bottom;

    return BlocListener<SaveOrderCubit, SaveOrderState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status == SaveOrderStatus.success) {
          Navigator.of(context).pop(true);
        }
      },
      child: Container(
        padding: EdgeInsets.only(bottom: bottomInsets),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.borderDark : AppColors.ringLight,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  'حفظ الطلب',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 24),

                // ── Order name
                _Label(text: 'اسم الطلب', isDark: isDark),
                const SizedBox(height: 8),
                BlocBuilder<SaveOrderCubit, SaveOrderState>(
                  buildWhen: (p, c) => p.status != c.status,
                  builder: (context, state) {
                    return TextFormField(
                      autofocus: true,
                      onChanged: context.read<SaveOrderCubit>().nameChanged,
                      decoration: _inputDecoration(
                        isDark: isDark,
                        hint: 'مثال: طلب يومي - 21 فبراير',
                        errorText:
                            state.status == SaveOrderStatus.error &&
                                state.errorMessage == 'اسم الطلب مطلوب'
                            ? state.errorMessage
                            : null,
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // ── Notes
                _Label(text: 'ملاحظات (اختياري)', isDark: isDark),
                const SizedBox(height: 8),
                TextFormField(
                  maxLines: 2,
                  onChanged: context.read<SaveOrderCubit>().notesChanged,
                  decoration: _inputDecoration(isDark: isDark, hint: 'ملاحظات إضافية...'),
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),

                // ── Date picker
                _Label(text: 'تاريخ الطلب', isDark: isDark),
                const SizedBox(height: 8),
                BlocBuilder<SaveOrderCubit, SaveOrderState>(
                  buildWhen: (p, c) => p.orderDate != c.orderDate,
                  builder: (context, state) {
                    return InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: state.orderDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null && context.mounted) {
                          context.read<SaveOrderCubit>().dateChanged(picked);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.inputDark : AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDark ? AppColors.ringDark : AppColors.ringLight,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 16,
                              color: isDark ? AppColors.textDarkTertiary : AppColors.textTertiary,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${state.orderDate.year}/${state.orderDate.month.toString().padLeft(2, '0')}/${state.orderDate.day.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // ── Save button
                BlocBuilder<SaveOrderCubit, SaveOrderState>(
                  buildWhen: (p, c) => p.status != c.status,
                  builder: (context, state) {
                    final isSaving = state.status == SaveOrderStatus.saving;
                    return FilledButton(
                      onPressed: isSaving ? null : () => context.read<SaveOrderCubit>().save(),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text(
                              'حفظ الطلب',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required bool isDark,
    required String hint,
    String? errorText,
  }) {
    return InputDecoration(
      hintText: hint,
      errorText: errorText,
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
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  final bool isDark;
  const _Label({required this.text, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.textDarkTertiary : AppColors.textTertiary,
      ),
    );
  }
}
