import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../cubit/bulk_order_cubit/bulk_order_cubit.dart';
import '../cubit/bulk_order_cubit/bulk_order_state.dart';
import '../widgets/bulk_order_item_card.dart';
import '../widgets/add_product_to_order_sheet.dart';

class BulkOrderPage extends StatelessWidget {
  const BulkOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Column(
        children: [
          // ── Sticky Header ─────────────────────────────────────────────────
          _BulkOrderHeader(),

          // ── Content ───────────────────────────────────────────────────────
          Expanded(
            child: BlocBuilder<BulkOrderCubit, BulkOrderState>(
              builder: (context, state) {
                return ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                  children: [
                    // Add product button
                    _AddProductButton(),
                    const SizedBox(height: 16),

                    // Items list
                    if (state.items.isEmpty)
                      _EmptyState()
                    else
                      ...List.generate(state.items.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: BulkOrderItemCard(
                            item: state.items[index],
                            onEdit: () =>
                                _showEditSheet(context, index, state.items[index].cartonCount),
                            onDelete: () => context.read<BulkOrderCubit>().removeItem(index),
                          ),
                        );
                      }),
                  ],
                );
              },
            ),
          ),
        ],
      ),

      // ── Bottom Action Bar ────────────────────────────────────────────────
      bottomNavigationBar: _BottomBar(),
    );
  }

  void _showEditSheet(BuildContext context, int index, int currentCount) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditCartonSheet(
        index: index,
        initialCount: currentCount,
        cubit: context.read<BulkOrderCubit>(),
      ),
    );
  }
}

// ── Header ─────────────────────────────────────────────────────────────────

class _BulkOrderHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark
          ? AppColors.backgroundDark.withValues(alpha: 0.95)
          : Colors.white.withValues(alpha: 0.95),
      child: SafeArea(
        bottom: false,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: isDark ? AppColors.borderDark : AppColors.ringLight),
            ),
          ),
          child: Row(
            children: [
              // Back button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: InkWell(
                  onTap: () => context.pop(),
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              const Expanded(
                child: Text(
                  'بناء الطلب',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: -0.3),
                ),
              ),
              // More options (placeholder)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.more_vert_rounded,
                  color: isDark ? AppColors.textDarkTertiary : AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Add Product Button ───────────────────────────────────────────────────────

class _AddProductButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<BulkOrderCubit>().loadProducts();
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => AddProductToOrderSheet(cubit: context.read<BulkOrderCubit>()),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.2),
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              child: const Icon(Icons.add, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
            const Text(
              'إضافة منتج',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty State ─────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(top: 64),
      child: Column(
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: AppColors.primary.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد منتجات في القائمة',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'اضغط على "إضافة منتج" للبدء',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.textDarkTertiary : AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bottom Bar ───────────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<BulkOrderCubit, BulkOrderState>(
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
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            border: Border(
              top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.ringLight),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 6,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.of(context).padding.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Summary row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'عدد المنتجات: ${state.items.length}',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      'إجمالي القطع: ${_formatNumber(state.totalPieces)}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Calculate button
              ElevatedButton.icon(
                onPressed: state.canCalculate
                    ? () {
                        final result = context.read<BulkOrderCubit>().calculate();
                        if (result != null) {
                          context.push(AppRouter.bulkOrderResults, extra: result);
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
                  foregroundColor: Colors.white,
                  elevation: state.canCalculate ? 8 : 0,
                  shadowColor: AppColors.primary.withValues(alpha: 0.3),
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.calculate_rounded),
                label: const Text(
                  'احسب المتطلبات',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 8),

              // Clear list text button
              TextButton(
                onPressed: state.items.isEmpty ? null : () => _showClearConfirm(context),
                child: Text(
                  'مسح القائمة',
                  style: TextStyle(
                    fontSize: 14,
                    color: state.items.isEmpty
                        ? (isDark ? AppColors.textDarkTertiary : AppColors.textTertiary)
                        : AppColors.danger,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showClearConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('مسح القائمة'),
        content: const Text('هل أنت متأكد من حذف جميع المنتجات من القائمة؟'),
        actions: [
          TextButton(onPressed: () => ctx.pop(), child: const Text('إلغاء')),
          TextButton(
            onPressed: () {
              context.read<BulkOrderCubit>().clearAll();
              ctx.pop();
            },
            child: const Text('مسح', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }
}

// ── Edit Carton Count Sheet ──────────────────────────────────────────────────

class _EditCartonSheet extends StatefulWidget {
  final int index;
  final int initialCount;
  final BulkOrderCubit cubit;
  const _EditCartonSheet({required this.index, required this.initialCount, required this.cubit});

  @override
  State<_EditCartonSheet> createState() => _EditCartonSheetState();
}

class _EditCartonSheetState extends State<_EditCartonSheet> {
  late int _count;
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _count = widget.initialCount;
    _ctrl = TextEditingController(text: _count.toString());
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.borderDark : AppColors.ringLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text('تعديل الكمية', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SheetRoundButton(
                  icon: Icons.remove,
                  onTap: () => setState(() {
                    if (_count > 1) {
                      _count--;
                      _ctrl.text = _count.toString();
                    }
                  }),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _ctrl,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                    decoration: const InputDecoration(border: InputBorder.none),
                    onChanged: (v) => setState(() => _count = int.tryParse(v) ?? _count),
                  ),
                ),
                const SizedBox(width: 16),
                _SheetRoundButton(
                  icon: Icons.add,
                  onTap: () => setState(() {
                    _count++;
                    _ctrl.text = _count.toString();
                  }),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_count > 0) {
                  widget.cubit.updateItem(widget.index, _count);
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('حفظ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetRoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _SheetRoundButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: isDark ? AppColors.surfaceDarkAlt : const Color(0xFFF8FAFC),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: SizedBox(width: 48, height: 48, child: Icon(icon)),
      ),
    );
  }
}

String _formatNumber(int n) {
  final s = n.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return buf.toString();
}
