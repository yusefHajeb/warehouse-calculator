import '../../domain/entities/ingredient.dart';

class IngredientModel extends Ingredient {
  const IngredientModel({required super.name, required super.quantityPerPiece});

  factory IngredientModel.fromMap(Map<String, dynamic> map) {
    return IngredientModel(
      name: map['name'] as String,
      quantityPerPiece: (map['quantity_per_piece'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'quantity_per_piece': quantityPerPiece};
  }

  factory IngredientModel.fromEntity(Ingredient ingredient) {
    if (ingredient is IngredientModel) return ingredient;
    return IngredientModel(name: ingredient.name, quantityPerPiece: ingredient.quantityPerPiece);
  }
}
