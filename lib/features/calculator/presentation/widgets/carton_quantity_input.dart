import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../cubit/order_calculator_cubit/order_calculator_cubit.dart';
import '../cubit/order_calculator_cubit/order_calculator_state.dart';

class CartonQuantityInput extends StatefulWidget {
  const CartonQuantityInput({super.key});

  @override
  State<CartonQuantityInput> createState() => _CartonQuantityInputState();
}

class _CartonQuantityInputState extends State<CartonQuantityInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<OrderCalculatorCubit, OrderCalculatorState>(
      listenWhen: (prev, curr) => prev.cartonCount != curr.cartonCount,
      listener: (context, state) {
        // Sync controller when count changes from +/- buttons
        final text = state.cartonCount > 0 ? state.cartonCount.toString() : '';
        if (_controller.text != text) {
          _controller.text = text;
          _controller.selection = TextSelection.fromPosition(TextPosition(offset: text.length));
        }
      },
      child: BlocBuilder<OrderCalculatorCubit, OrderCalculatorState>(
        buildWhen: (prev, curr) => prev.cartonCount != curr.cartonCount,
        builder: (context, state) {
          final cubit = context.read<OrderCalculatorCubit>();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Text(
                  AppStrings.calcCartonCount,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                    color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Big number input card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDarkAlt : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    width: 2,
                    color: isDark ? AppColors.borderDark : const Color(0xFFF1F5F9),
                  ),
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
                child: Column(
                  children: [
                    // "كرتون" label
                    Text(
                      AppStrings.calcCartonLabel,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.textDarkTertiary : AppColors.textTertiary,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Large numeric input
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48),
                      child: TextField(
                        controller: _controller,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        autofocus: false,
                        onChanged: (value) => cubit.setCartonCount(value),
                        style: TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -1,
                          color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          fillColor: Colors.transparent,
                          hintText: '٠',
                          hintStyle: TextStyle(
                            fontSize: 56,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -1,
                            color: isDark ? AppColors.surfaceDarkAlt : const Color(0xFFE2E8F0),
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // +/- buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _RoundButton(icon: Icons.remove, onTap: () => cubit.decrement()),
                        const SizedBox(width: 16),
                        _RoundButton(icon: Icons.add, onTap: () => cubit.increment()),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Min / max hints
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.calcMinLabel,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.textDarkTertiary : AppColors.textTertiary,
                      ),
                    ),
                    Text(
                      AppStrings.calcMaxLabel,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.textDarkTertiary : AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: isDark ? AppColors.surfaceDarkAlt : const Color(0xFFF8FAFC),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(icon, color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary),
        ),
      ),
    );
  }
}
