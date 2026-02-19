import 'package:equatable/equatable.dart';
import '../../../product/domain/entities/product.dart';

/// Result of a carton order calculation.
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
