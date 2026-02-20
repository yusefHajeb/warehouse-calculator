import 'package:uuid/uuid.dart';
import '../../domain/entities/ingredient.dart';

class IngredientModel extends Ingredient {
  const IngredientModel({required super.id, required super.name, required super.quantityPerPiece});

  // ── From a JOIN row of (ingredients + product_ingredients) ─────────────────

  /// Used when loading product ingredients via:
  /// SELECT i.id, i.name, pi.grams_per_piece
  /// FROM ingredients i JOIN product_ingredients pi ON i.id = pi.ingredient_id
  /// WHERE pi.product_id = ?
  factory IngredientModel.fromJoinRow(Map<String, dynamic> map) {
    return IngredientModel(
      id: map['id'] as String,
      name: map['name'] as String,
      quantityPerPiece: (map['grams_per_piece'] as num).toDouble(),
    );
  }

  // ── From ingredients table row only (no grams_per_piece) ──────────────────
  factory IngredientModel.fromIngredientRow(Map<String, dynamic> map) {
    return IngredientModel(
      id: map['id'] as String,
      name: map['name'] as String,
      quantityPerPiece: 0, // not available from ingredients table alone
    );
  }

  // ── For inserting into the ingredients table ───────────────────────────────
  Map<String, dynamic> toIngredientMap() => {'id': id, 'name': name};

  // ── For inserting into product_ingredients ────────────────────────────────
  Map<String, dynamic> toLinkMap(String productId) => {
    'product_id': productId,
    'ingredient_id': id,
    'grams_per_piece': quantityPerPiece,
  };

  factory IngredientModel.fromEntity(Ingredient ingredient) {
    if (ingredient is IngredientModel) return ingredient;
    return IngredientModel(
      id: ingredient.id.isNotEmpty ? ingredient.id : const Uuid().v4(),
      name: ingredient.name,
      quantityPerPiece: ingredient.quantityPerPiece,
    );
  }
}
