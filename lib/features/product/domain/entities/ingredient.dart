import 'package:equatable/equatable.dart';

class Ingredient extends Equatable {
  final String id;
  final String name;
  final double quantityPerPiece;

  const Ingredient({required this.id, required this.name, required this.quantityPerPiece});

  Ingredient copyWith({String? id, String? name, double? quantityPerPiece}) {
    return Ingredient(
      id: id ?? this.id,
      name: name ?? this.name,
      quantityPerPiece: quantityPerPiece ?? this.quantityPerPiece,
    );
  }

  @override
  List<Object?> get props => [name, quantityPerPiece];
}
