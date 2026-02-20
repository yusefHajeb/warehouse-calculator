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

  /// Builds a ProductModel from a products table row.
  /// Ingredients must be supplied separately (loaded via JOIN).
  factory ProductModel.fromMap(
    Map<String, dynamic> map, {
    List<IngredientModel> ingredients = const [],
  }) {
    return ProductModel(
      id: map['id'] as String,
      name: map['name'] as String,
      piecesPerBox: map['pieces_per_box'] as int,
      boxesPerCarton: map['boxes_per_carton'] as int,
      ingredients: ingredients,
      createdAt: _parseDateTime(map['created_at']),
      updatedAt: _parseDateTime(map['updated_at']),
    );
  }

  /// Produces a map for inserting/updating the products table only.
  /// Does NOT include ingredients (those go to product_ingredients).
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'pieces_per_box': piecesPerBox,
      'boxes_per_carton': boxesPerCarton,
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
