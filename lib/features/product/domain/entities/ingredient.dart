import 'package:equatable/equatable.dart';

class Ingredient extends Equatable {
  final String name;
  final double quantityPerPiece;

  const Ingredient({required this.name, required this.quantityPerPiece});

  Ingredient copyWith({String? name, double? quantityPerPiece}) {
    return Ingredient(
      name: name ?? this.name,
      quantityPerPiece: quantityPerPiece ?? this.quantityPerPiece,
    );
  }

  @override
  List<Object?> get props => [name, quantityPerPiece];
}
