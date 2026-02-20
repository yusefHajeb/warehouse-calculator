import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/calculation_result.dart';
import '../cubit/bulk_order_cubit/bulk_order_cubit.dart';
import '../cubit/bulk_order_cubit/bulk_order_state.dart';

/// Bottom sheet to search for a product, set a carton count,
/// and add it as a [BulkOrderItem] to the active bulk order.
class AddProductToOrderSheet extends StatefulWidget {
  final BulkOrderCubit cubit;

  const AddProductToOrderSheet({super.key, required this.cubit});

  @override
  State<AddProductToOrderSheet> createState() => _AddProductToOrderSheetState();
}

class _AddProductToOrderSheetState extends State<AddProductToOrderSheet> {
  final TextEditingController _searchCtrl = TextEditingController();
  final TextEditingController _countCtrl = TextEditingController(text: '1');

  int _cartonCount = 1;
  int _selectedIndex = -1; // index into cubit.state.allProducts

  @override
  void dispose() {
    _searchCtrl.dispose();
    _countCtrl.dispose();
    super.dispose();
  }

  void _increment() {
    setState(() {
      _cartonCount++;
      _countCtrl.text = _cartonCount.toString();
    });
  }

  void _decrement() {
    if (_cartonCount > 1) {
      setState(() {
        _cartonCount--;
        _countCtrl.text = _cartonCount.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider<BulkOrderCubit>.value(
      value: widget.cubit,
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Handle bar
              const SizedBox(height: 12),
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
              const SizedBox(height: 16),

              // ── Title row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'إضافة منتج للطلب',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(
                        Icons.close_rounded,
                        color: isDark ? AppColors.textDarkTertiary : AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── Search field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _searchCtrl,
                  textAlign: TextAlign.right,
                  onChanged: (q) {
                    widget.cubit.filterProducts(q);
                    setState(() => _selectedIndex = -1);
                  },
                  decoration: InputDecoration(
                    hintText: 'ابحث عن منتج...',
                    hintStyle: TextStyle(
                      color: isDark ? AppColors.textDarkTertiary : AppColors.textTertiary,
                    ),
                    filled: true,
                    fillColor: isDark ? AppColors.surfaceDarkAlt : const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: const Icon(Icons.search_rounded),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // ── Scrollable product list
              Flexible(
                child: BlocBuilder<BulkOrderCubit, BulkOrderState>(
                  builder: (context, state) {
                    if (state.status == BulkOrderStatus.loading) {
                      return const Padding(
                        padding: EdgeInsets.all(32),
                        child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                      );
                    }
                    if (state.allProducts.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(32),
                        child: Center(
                          child: Text(
                            'لا توجد منتجات',
                            style: TextStyle(
                              color: isDark ? AppColors.textDarkTertiary : AppColors.textTertiary,
                            ),
                          ),
                        ),
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      shrinkWrap: true,
                      itemCount: state.allProducts.length,
                      separatorBuilder: (_, idx) => Divider(
                        height: 1,
                        color: isDark ? AppColors.borderDark : AppColors.ringLight,
                      ),
                      itemBuilder: (context, i) {
                        final p = state.allProducts[i];
                        final isSelected = i == _selectedIndex;
                        return InkWell(
                          onTap: () => setState(() => _selectedIndex = i),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary.withValues(alpha: 0.08)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                if (isSelected)
                                  const Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Icon(
                                      Icons.check_circle_rounded,
                                      color: AppColors.primary,
                                      size: 18,
                                    ),
                                  ),
                                Expanded(
                                  child: Text(
                                    p.name,
                                    style: TextStyle(
                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                      color: isSelected
                                          ? AppColors.primary
                                          : (isDark
                                                ? AppColors.textDarkPrimary
                                                : AppColors.textPrimary),
                                    ),
                                  ),
                                ),
                                Text(
                                  '${p.piecesPerCarton} قطعة/كرتون',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark
                                        ? AppColors.textDarkTertiary
                                        : AppColors.textTertiary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),
              Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.ringLight),
              const SizedBox(height: 16),

              // ── Carton count stepper
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'عدد الكراتين',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _StepperButton(icon: Icons.remove, onTap: _decrement, isDark: isDark),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _countCtrl,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: isDark
                                  ? AppColors.surfaceDarkAlt
                                  : const Color(0xFFF8FAFC),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onChanged: (v) =>
                                setState(() => _cartonCount = int.tryParse(v) ?? _cartonCount),
                          ),
                        ),
                        const SizedBox(width: 12),
                        _StepperButton(icon: Icons.add, onTap: _increment, isDark: isDark),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Add button
              BlocBuilder<BulkOrderCubit, BulkOrderState>(
                builder: (context, state) {
                  final canAdd =
                      _selectedIndex >= 0 &&
                      _selectedIndex < state.allProducts.length &&
                      _cartonCount > 0;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: canAdd
                          ? () {
                              final product = state.allProducts[_selectedIndex];
                              widget.cubit.addItem(
                                BulkOrderItem(product: product, cartonCount: _cartonCount),
                              );
                              Navigator.of(context).pop();
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.35),
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'إضافة إلى القائمة',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;

  const _StepperButton({required this.icon, required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDark ? AppColors.surfaceDarkAlt : const Color(0xFFF1F5F9),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(padding: const EdgeInsets.all(12), child: Icon(icon, size: 20)),
      ),
    );
  }
}
