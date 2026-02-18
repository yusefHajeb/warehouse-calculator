import 'dart:convert';
import '../../domain/entities/product.dart';
import 'ingredient_model.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.piecesPerBox,
    required super.boxesPerCarton,
    required super.ingredients,
    super.createdAt,
    super.updatedAt,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    final rawIngredients = map['ingredients'];
    final List ingredientList = rawIngredients is String
        ? jsonDecode(rawIngredients) as List
        : rawIngredients as List;

    return ProductModel(
      id: map['id'] as String,
      name: map['name'] as String,
      piecesPerBox: map['pieces_per_box'] as int,
      boxesPerCarton: map['boxes_per_carton'] as int,
      ingredients: ingredientList
          .map((e) => IngredientModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      createdAt: _parseDateTime(map['created_at']),
      updatedAt: _parseDateTime(map['updated_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'pieces_per_box': piecesPerBox,
      'boxes_per_carton': boxesPerCarton,
      'ingredients': jsonEncode(
        ingredients.map((e) => IngredientModel.fromEntity(e).toMap()).toList(),
      ),
      'created_at': createdAt?.millisecondsSinceEpoch,
      'updated_at': updatedAt?.millisecondsSinceEpoch,
    };
  }

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      piecesPerBox: product.piecesPerBox,
      boxesPerCarton: product.boxesPerCarton,
      ingredients: product.ingredients,
      createdAt: product.createdAt,
      updatedAt: product.updatedAt,
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
