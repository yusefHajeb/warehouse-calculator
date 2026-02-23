import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../calculator/domain/entities/calculation_result.dart';
import '../../data/services/order_pdf_service.dart';
import '../../domain/entities/saved_order.dart';
import '../cubit/order_detail_cubit.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key});

  Future<void> _exportPdf(BuildContext context, SavedOrder order) async {
    try {
      await sl<OrderPdfService>().generateAndShare(order);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في إنشاء PDF: $e'), backgroundColor: AppColors.danger),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      floatingActionButton: BlocBuilder<OrderDetailCubit, OrderDetailState>(
        builder: (context, state) {
          if (state.order == null) return const SizedBox.shrink();
          return FloatingActionButton.extended(
            onPressed: () => _exportPdf(context, state.order!),
            backgroundColor: AppColors.primary,
            icon: const Icon(Icons.picture_as_pdf_rounded, color: Colors.white),
            label: const Text(
              'تصدير PDF',
              style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
            ),
          );
        },
      ),
      body: BlocBuilder<OrderDetailCubit, OrderDetailState>(
        builder: (context, state) {
          if (state.status == OrderDetailStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == OrderDetailStatus.error || state.order == null) {
            return Center(
              child: Text(
                state.errorMessage ?? 'خطأ في تحميل الطلب',
                style: const TextStyle(color: AppColors.danger),
              ),
            );
          }
          final order = state.order!;
          return Column(
            children: [
              _DetailHeader(order: order, isDark: isDark),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
                  children: [
                    _OrderInfoCard(order: order, isDark: isDark),
                    const SizedBox(height: 24),

                    // Phase 1 label
                    _SectionTitle(
                      icon: Icons.widgets_rounded,
                      label: 'Phase 1 — تفاصيل كل منتج',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 12),

                    ...List.generate(order.items.length, (i) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _ItemCard(item: order.items[i], index: i + 1, isDark: isDark),
                      );
                    }),

                    const SizedBox(height: 16),

                    // Phase 2 label
                    _SectionTitle(
                      icon: Icons.merge_rounded,
                      label: 'Phase 2 — المواد الخام المجمعة',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 12),

                    _AggregatedTable(order: order, isDark: isDark),
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

// ── Header ──────────────────────────────────────────────────────────────────────

class _DetailHeader extends StatelessWidget {
  final SavedOrder order;
  final bool isDark;
  const _DetailHeader({required this.order, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 16,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.85)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${order.orderDate.year}/${order.orderDate.month.toString().padLeft(2, '0')}/${order.orderDate.day.toString().padLeft(2, '0')}',
                  style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.8)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Info card ────────────────────────────────────────────────────────────────────

class _OrderInfoCard extends StatelessWidget {
  final SavedOrder order;
  final bool isDark;
  const _OrderInfoCard({required this.order, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.ringLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _StatChip(label: 'إجمالي القطع', value: _fmt(order.totalPieces), isDark: isDark),
              const SizedBox(width: 16),
              _StatChip(
                label: 'إجمالي الوزن',
                value: '${order.totalWeightKg.toStringAsFixed(1)} كجم',
                isDark: isDark,
              ),
              const SizedBox(width: 16),
              _StatChip(
                label: 'عدد المنتجات',
                value: order.items.length.toString(),
                isDark: isDark,
              ),
            ],
          ),
          if (order.notes != null && order.notes!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              order.notes!,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  const _StatChip({required this.label, required this.value, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isDark ? AppColors.textDarkTertiary : AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Per-product Card ─────────────────────────────────────────────────────────

class _ItemCard extends StatelessWidget {
  final SavedOrderItem item;
  final int index;
  final bool isDark;
  const _ItemCard({required this.item, required this.index, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.ringLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Card header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    '$index',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.productName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                    ),
                  ),
                ),
                Text(
                  '${item.cartonCount} كرتون  •  ${_fmt(item.totalPieces)} قطعة',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.textDarkTertiary : AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          // Materials table
          Padding(
            padding: const EdgeInsets.all(12),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  children: [
                    _TableHeader('المكون', isDark),
                    _TableHeader('لكل قطعة (غ)', isDark),
                    _TableHeader('المطلوب (كجم)', isDark),
                  ],
                ),
                ...item.materials.map(
                  (m) => TableRow(
                    children: [
                      _TableCell(m.ingredientName, isDark),
                      _TableCell('${m.perPieceGrams}', isDark),
                      _TableCell(m.requiredKg.toStringAsFixed(2), isDark, highlight: true),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Aggregated Table ─────────────────────────────────────────────────────────

class _AggregatedTable extends StatelessWidget {
  final SavedOrder order;
  final bool isDark;
  const _AggregatedTable({required this.order, required this.isDark});

  @override
  Widget build(BuildContext context) {
    // Aggregate materials by ingredientId across all items
    final Map<String, MaterialRequirement> agg = {};
    for (final item in order.items) {
      for (final m in item.materials) {
        final key = m.ingredientId.isNotEmpty ? m.ingredientId : m.ingredientName;
        if (agg.containsKey(key)) {
          agg[key] = MaterialRequirement(
            ingredientId: m.ingredientId,
            ingredientName: m.ingredientName,
            perPieceGrams: agg[key]!.perPieceGrams,
            requiredKg: agg[key]!.requiredKg + m.requiredKg,
          );
        } else {
          agg[key] = m;
        }
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.ringLight),
      ),
      padding: const EdgeInsets.all(12),
      child: Table(
        columnWidths: const {0: FlexColumnWidth(3), 1: FlexColumnWidth(2)},
        children: [
          TableRow(
            children: [
              _TableHeader('المكون', isDark),
              _TableHeader('الكمية الإجمالية (كجم)', isDark),
            ],
          ),
          ...agg.values.map(
            (m) => TableRow(
              children: [
                _TableCell(m.ingredientName, isDark),
                _TableCell(m.requiredKg.toStringAsFixed(2), isDark, highlight: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section title ────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  const _SectionTitle({required this.icon, required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ── Table helpers ────────────────────────────────────────────────────────────

Widget _TableHeader(String text, bool isDark) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: isDark ? AppColors.textDarkTertiary : AppColors.textTertiary,
      ),
    ),
  );
}

Widget _TableCell(String text, bool isDark, {bool highlight = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: highlight ? FontWeight.w700 : FontWeight.w400,
        color: highlight
            ? AppColors.primary
            : (isDark ? AppColors.textDarkPrimary : AppColors.textPrimary),
      ),
    ),
  );
}

// ── Formatting helper ────────────────────────────────────────────────────────

String _fmt(int n) {
  final s = n.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return buf.toString();
}
