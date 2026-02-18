import 'package:equatable/equatable.dart';
import 'ingredient.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final int piecesPerBox;
  final int boxesPerCarton;
  final List<Ingredient> ingredients;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Product({
    required this.id,
    required this.name,
    required this.piecesPerBox,
    required this.boxesPerCarton,
    required this.ingredients,
    this.createdAt,
    this.updatedAt,
  });

  factory Product.empty() {
    return const Product(id: '', name: '', piecesPerBox: 0, boxesPerCarton: 0, ingredients: []);
  }

  int get piecesPerCarton => piecesPerBox * boxesPerCarton;

  Product copyWith({
    String? id,
    String? name,
    int? piecesPerBox,
    int? boxesPerCarton,
    List<Ingredient>? ingredients,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      piecesPerBox: piecesPerBox ?? this.piecesPerBox,
      boxesPerCarton: boxesPerCarton ?? this.boxesPerCarton,
      ingredients: ingredients ?? this.ingredients,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    piecesPerBox,
    boxesPerCarton,
    ingredients,
    createdAt,
    updatedAt,
  ];
}
