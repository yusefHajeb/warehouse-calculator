import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/calculation_result.dart';
import '../cubit/bulk_result_cubit/bulk_result_cubit.dart';

/// Results page for a bulk production order.
/// Shows:
///  • Phase 1 — per-product cards each with their individual ingredient table.
///  • Phase 2 — aggregated (shared ingredients merged) at the bottom.
class BulkResultsPage extends StatelessWidget {
  const BulkResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: BlocBuilder<BulkResultCubit, BulkCalculationResult>(
        builder: (context, result) {
          return Column(
            children: [
              // ─── Header
              _ResultsHeader(result: result),

              // ─── Scrollable content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
                  children: [
                    // ── Overall summary card
                    _OverallSummaryCard(result: result),
                    const SizedBox(height: 24),

                    // ── Phase 1 Section label
                    _SectionTitle(
                      icon: Icons.widgets_rounded,
                      label: 'Phase 1 — حساب كل منتج على حدة',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 12),

                    // ── Per-product cards (Phase 1)
                    ...List.generate(result.productResults.length, (i) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _ProductBreakdownCard(
                          orderItem: result.items[i],
                          calcResult: result.productResults[i],
                          index: i + 1,
                          isDark: isDark,
                        ),
                      );
                    }),

                    const SizedBox(height: 16),

                    // ── Phase 2 Section label
                    _SectionTitle(
                      icon: Icons.merge_rounded,
                      label: 'Phase 2 — المواد الخام المجمعة',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 12),

                    // ── Aggregated materials table (Phase 2)
                    _AggregatedMaterialsTable(result: result, isDark: isDark),
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

// ── Header ─────────────────────────────────────────────────────────────────────

class _ResultsHeader extends StatelessWidget {
  final BulkCalculationResult result;
  const _ResultsHeader({required this.result});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? AppColors.backgroundDark : Colors.white,
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
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'نتائج الطلب المجمع',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '${result.items.length} منتجات  •  ${_fmt(result.totalPieces)} قطعة',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.textDarkTertiary : AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Overall summary card ──────────────────────────────────────────────────────

class _OverallSummaryCard extends StatelessWidget {
  final BulkCalculationResult result;
  const _OverallSummaryCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1347D0), AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.30),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'إجمالي القطع',
                    style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.7)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _fmt(result.totalPieces),
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -1,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.inventory_2_rounded, color: Colors.white, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(height: 1, color: Colors.white.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatChip(label: 'عدد المنتجات', value: '${result.items.length}'),
              _StatChip(label: 'عدد المكونات', value: '${result.materials.length}'),
              _StatChip(
                label: 'إجمالي الوزن',
                value: '${result.totalWeightKg.toStringAsFixed(1)} كجم',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.6))),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ],
    );
  }
}

// ── Section title ─────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  const _SectionTitle({required this.icon, required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: AppColors.primary),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Phase 1: Per-product breakdown card ───────────────────────────────────────

class _ProductBreakdownCard extends StatefulWidget {
  final BulkOrderItem orderItem;
  final CalculationResult calcResult;
  final int index;
  final bool isDark;

  const _ProductBreakdownCard({
    required this.orderItem,
    required this.calcResult,
    required this.index,
    required this.isDark,
  });

  @override
  State<_ProductBreakdownCard> createState() => _ProductBreakdownCardState();
}

class _ProductBreakdownCardState extends State<_ProductBreakdownCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final r = widget.calcResult;
    final isDark = widget.isDark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.ringLight),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // ── Product header row
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Index badge
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${widget.index}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Name and stats
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r.product.name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${r.cartonCount} كرتون  ×  ${r.product.boxesPerCarton} صندوق  ×  ${r.product.piecesPerBox} قطعة',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? AppColors.textDarkTertiary : AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Total pieces
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _fmt(r.totalPieces),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        'قطعة',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.textDarkTertiary : AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _expanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    color: isDark ? AppColors.textDarkTertiary : AppColors.textTertiary,
                  ),
                ],
              ),
            ),
          ),

          // ── Ingredient table (expandable)
          if (_expanded) ...[
            Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.ringLight),
            // Formula bar
            Container(
              width: double.infinity,
              color: isDark
                  ? AppColors.primary.withValues(alpha: 0.08)
                  : AppColors.primary.withValues(alpha: 0.04),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                '${_fmt(r.totalPieces)} قطعة  ×  المكون (جم/قطعة)  ÷  1000  =  كجم مطلوب',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? const Color(0xFF60A5FA) : AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
            // Header
            _TableHeader(isDark: isDark),
            // Rows
            ...r.materials.map((m) => _IngredientRow(material: m, isDark: isDark)),
            // Sub-total
            Divider(height: 1, color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
            _SubtotalRow(result: r, isDark: isDark),
          ],
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  final bool isDark;
  const _TableHeader({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      color: isDark ? AppColors.textDarkTertiary : AppColors.textSecondary,
    );
    return Container(
      color: isDark ? AppColors.surfaceDarkAlt.withValues(alpha: 0.5) : const Color(0xFFF8FAFC),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(flex: 4, child: Text('المكوّن', style: style)),
          Expanded(
            flex: 3,
            child: Text('جم/قطعة', textAlign: TextAlign.center, style: style),
          ),
          Expanded(
            flex: 3,
            child: Text('كجم مطلوب', textAlign: TextAlign.end, style: style),
          ),
        ],
      ),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  final MaterialRequirement material;
  final bool isDark;
  const _IngredientRow({required this.material, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              material.ingredientName,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              '${material.perPieceGrams.toStringAsFixed(1)} جم',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              '${material.requiredKg.toStringAsFixed(2)} كجم',
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isDark ? const Color(0xFF60A5FA) : AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubtotalRow extends StatelessWidget {
  final CalculationResult result;
  final bool isDark;
  const _SubtotalRow({required this.result, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDark ? AppColors.backgroundDark.withValues(alpha: 0.5) : const Color(0xFFF8FAFC),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              'إجمالي الوزن',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              '${result.totalWeightKg.toStringAsFixed(2)} كجم',
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Phase 2: Aggregated materials table ───────────────────────────────────────

class _AggregatedMaterialsTable extends StatelessWidget {
  final BulkCalculationResult result;
  final bool isDark;
  const _AggregatedMaterialsTable({required this.result, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.ringLight),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Note banner: shows which ingredients were merged
          if (result.materials.length <
              result.productResults.fold(0, (s, pr) => s + pr.materials.length))
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: isDark ? AppColors.success.withValues(alpha: 0.1) : AppColors.successLight,
              child: Row(
                children: [
                  Icon(
                    Icons.merge_type_rounded,
                    size: 14,
                    color: isDark ? AppColors.successTextDark : AppColors.successDark,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'تم دمج المكونات المشتركة بين المنتجات تلقائيًا',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.successTextDark : AppColors.successDark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Header
          _TableHeader(isDark: isDark),
          Divider(height: 1, color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),

          // Rows
          ...List.generate(result.materials.length, (i) {
            final m = result.materials[i];
            return Column(
              children: [
                _IngredientRow(material: m, isDark: isDark),
                if (i < result.materials.length - 1)
                  Divider(
                    height: 1,
                    color: isDark ? AppColors.borderDark : const Color(0xFFF1F5F9),
                  ),
              ],
            );
          }),

          // Footer total
          Divider(height: 1, color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
          Container(
            color: isDark
                ? AppColors.backgroundDark.withValues(alpha: 0.5)
                : const Color(0xFFF8FAFC),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'الإجمالي الكلي',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Text(
                    '${result.totalWeightKg.toStringAsFixed(2)} كجم',
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
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

String _fmt(int n) {
  final s = n.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return buf.toString();
}
