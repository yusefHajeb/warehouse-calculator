import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../cubit/order_calculator_cubit/order_calculator_cubit.dart';
import '../cubit/order_calculator_cubit/order_calculator_state.dart';

class CalculateButton extends StatelessWidget {
  const CalculateButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<OrderCalculatorCubit, OrderCalculatorState>(
      listenWhen: (prev, curr) => prev.validationError != curr.validationError,
      listener: (context, state) {
        if (state.validationError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.validationError!),
              backgroundColor: AppColors.danger,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          );
        }
      },
      buildWhen: (prev, curr) => prev.canCalculate != curr.canCalculate,
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            border: Border(
              top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
          ),
          child: ElevatedButton(
            onPressed: () {
              final result = context.read<OrderCalculatorCubit>().calculate();
              if (result != null) {
                context.push(AppRouter.calculationResults, extra: result);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: state.canCalculate
                  ? AppColors.primary
                  : AppColors.primary.withValues(alpha: 0.4),
              foregroundColor: Colors.white,
              elevation: state.canCalculate ? 8 : 0,
              shadowColor: AppColors.primary.withValues(alpha: 0.25),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              minimumSize: const Size.fromHeight(56),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.calculate_rounded, size: 24),
                SizedBox(width: 8),
                Text(
                  AppStrings.calcButton,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
