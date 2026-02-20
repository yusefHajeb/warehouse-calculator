import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../product/domain/usecases/get_products.dart';
import '../../../../product/domain/usecases/search_products.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/calculation_result.dart';
import 'bulk_order_state.dart';

class BulkOrderCubit extends Cubit<BulkOrderState> {
  final GetProducts getProducts;
  final SearchProducts searchProducts;

  BulkOrderCubit({required this.getProducts, required this.searchProducts})
    : super(const BulkOrderState());

  Future<void> loadProducts() async {
    if (state.allProducts.isNotEmpty) return;
    emit(state.copyWith(status: BulkOrderStatus.loading));
    final result = await getProducts(NoParams());
    result.fold(
      (failure) =>
          emit(state.copyWith(status: BulkOrderStatus.error, errorMessage: failure.message)),
      (products) => emit(state.copyWith(status: BulkOrderStatus.loaded, allProducts: products)),
    );
  }

  Future<void> filterProducts(String query) async {
    if (query.isEmpty) {
      await loadProducts();
      return;
    }
    final result = await searchProducts(query);
    result.fold((_) {}, (products) => emit(state.copyWith(allProducts: products)));
  }

  // ── Order list management ─────────────────────────────────────────────────

  void addItem(BulkOrderItem item) {
    emit(state.copyWith(items: [...state.items, item], clearValidation: true));
  }

  void updateItem(int index, int newCartonCount) {
    if (newCartonCount < 1) return;
    final updated = List<BulkOrderItem>.from(state.items);
    updated[index] = updated[index].copyWith(cartonCount: newCartonCount);
    emit(state.copyWith(items: updated));
  }

  void removeItem(int index) {
    final updated = List<BulkOrderItem>.from(state.items)..removeAt(index);
    emit(state.copyWith(items: updated));
  }

  void clearAll() {
    emit(const BulkOrderState());
  }

  // ── Calculation ───────────────────────────────────────────────────────────

  /// Two-phase calculation:
  /// - Phase 1: compute [CalculationResult] for each order item individually.
  /// - Phase 2: merge all ingredients across products (same name → summed).
  BulkCalculationResult? calculate() {
    if (state.items.isEmpty) {
      emit(state.copyWith(validationError: 'أضف منتجًا واحدًا على الأقل'));
      return null;
    }

    // ── Phase 1: per-product calculations ──────────────────────────────────
    final List<CalculationResult> productResults = [];

    for (final item in state.items) {
      // totalPieces = cartons × boxesPerCarton × piecesPerBox
      final totalPieces =
          item.cartonCount * item.product.boxesPerCarton * item.product.piecesPerBox;

      // ingredientTotalGrams = totalPieces × gramPerPiece  → convert to kg
      final itemMaterials = item.product.ingredients.map((ingredient) {
        final requiredKg = totalPieces * ingredient.quantityPerPiece / 1000.0;
        return MaterialRequirement(
          ingredientId: ingredient.id,
          ingredientName: ingredient.name,
          perPieceGrams: ingredient.quantityPerPiece,
          requiredKg: requiredKg,
        );
      }).toList();

      final itemWeightKg = itemMaterials.fold(0.0, (s, m) => s + m.requiredKg);

      productResults.add(
        CalculationResult(
          product: item.product,
          cartonCount: item.cartonCount,
          totalPieces: totalPieces,
          materials: itemMaterials,
          totalWeightKg: itemWeightKg,
          calculatedAt: DateTime.now(),
        ),
      );
    }

    // ── Phase 2: aggregate shared ingredients by id ────────────────────────
    final Map<String, _IngredientAccumulator> accumulator = {};

    for (final pr in productResults) {
      for (final m in pr.materials) {
        accumulator.update(
          m.ingredientId, // ← stable id, not mutable name string
          (a) => _IngredientAccumulator(
            ingredientId: m.ingredientId,
            ingredientName: a.ingredientName,
            perPieceGrams: a.perPieceGrams,
            totalKg: a.totalKg + m.requiredKg,
          ),
          ifAbsent: () => _IngredientAccumulator(
            ingredientId: m.ingredientId,
            ingredientName: m.ingredientName,
            perPieceGrams: m.perPieceGrams,
            totalKg: m.requiredKg,
          ),
        );
      }
    }

    final aggregatedMaterials = accumulator.values
        .map(
          (a) => MaterialRequirement(
            ingredientId: a.ingredientId,
            ingredientName: a.ingredientName,
            perPieceGrams: a.perPieceGrams,
            requiredKg: a.totalKg,
          ),
        )
        .toList();

    final totalPiecesAll = productResults.fold(0, (s, pr) => s + pr.totalPieces);
    final totalWeightKg = aggregatedMaterials.fold(0.0, (s, m) => s + m.requiredKg);

    return BulkCalculationResult(
      items: List.unmodifiable(state.items),
      productResults: List.unmodifiable(productResults),
      materials: aggregatedMaterials,
      totalPieces: totalPiecesAll,
      totalWeightKg: totalWeightKg,
      calculatedAt: DateTime.now(),
    );
  }
}

/// Internal accumulator used during Phase 2 ingredient merging.
class _IngredientAccumulator {
  final String ingredientId;
  final String ingredientName;
  final double perPieceGrams;
  final double totalKg;
  const _IngredientAccumulator({
    required this.ingredientId,
    required this.ingredientName,
    required this.perPieceGrams,
    required this.totalKg,
  });
}
