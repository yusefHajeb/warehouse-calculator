import 'package:equatable/equatable.dart';
import '../../../product/domain/entities/product.dart';

/// Result of a single-product carton order calculation.
class CalculationResult extends Equatable {
  final Product product;
  final int cartonCount;
  final int totalPieces;
  final List<MaterialRequirement> materials;
  final double totalWeightKg;
  final DateTime calculatedAt;

  const CalculationResult({
    required this.product,
    required this.cartonCount,
    required this.totalPieces,
    required this.materials,
    required this.totalWeightKg,
    required this.calculatedAt,
  });

  @override
  List<Object?> get props => [
    product,
    cartonCount,
    totalPieces,
    materials,
    totalWeightKg,
    calculatedAt,
  ];
}

/// Per-ingredient material requirement.
class MaterialRequirement extends Equatable {
  final String ingredientName;
  final double perPieceGrams;
  final double requiredKg;

  const MaterialRequirement({
    required this.ingredientName,
    required this.perPieceGrams,
    required this.requiredKg,
  });

  @override
  List<Object?> get props => [ingredientName, perPieceGrams, requiredKg];
}

// ─────────────────────────────────────────────────────────
//  Bulk Order Entities
// ─────────────────────────────────────────────────────────

/// One line in a bulk production order: which product + how many cartons to produce.
/// NOTE: This is NOT related to [Ingredient].
///       It is an order-level entry pointing to a [Product].
class BulkOrderItem extends Equatable {
  final Product product;
  final int cartonCount;

  const BulkOrderItem({required this.product, required this.cartonCount});

  /// Total pieces = cartons × boxesPerCarton × piecesPerBox.
  int get totalPieces => cartonCount * product.boxesPerCarton * product.piecesPerBox;

  BulkOrderItem copyWith({Product? product, int? cartonCount}) =>
      BulkOrderItem(product: product ?? this.product, cartonCount: cartonCount ?? this.cartonCount);

  @override
  List<Object?> get props => [product, cartonCount];
}

/// Aggregated result after calculating across all order lines.
/// - [productResults] = Phase 1: individual calculation per product (with its own ingredient table).
/// - [materials] = Phase 2: all ingredients summed across every product (same name → merged).
class BulkCalculationResult extends Equatable {
  final List<BulkOrderItem> items;

  /// Phase 1 – per-product individual results (same order as [items]).
  final List<CalculationResult> productResults;

  /// Phase 2 – aggregated ingredients across all products.
  final List<MaterialRequirement> materials;
  final int totalPieces;
  final double totalWeightKg;
  final DateTime calculatedAt;

  const BulkCalculationResult({
    required this.items,
    required this.productResults,
    required this.materials,
    required this.totalPieces,
    required this.totalWeightKg,
    required this.calculatedAt,
  });

  @override
  List<Object?> get props => [
    items,
    productResults,
    materials,
    totalPieces,
    totalWeightKg,
    calculatedAt,
  ];
}
