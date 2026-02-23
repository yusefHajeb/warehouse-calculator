import 'package:equatable/equatable.dart';
import '../../../calculator/domain/entities/calculation_result.dart';

/// A persisted bulk order.
class SavedOrder extends Equatable {
  final String id;
  final String name;
  final String? notes;
  final DateTime orderDate;
  final int totalPieces;
  final double totalWeightKg;
  final DateTime createdAt;
  final List<SavedOrderItem> items;

  const SavedOrder({
    required this.id,
    required this.name,
    this.notes,
    required this.orderDate,
    required this.totalPieces,
    required this.totalWeightKg,
    required this.createdAt,
    this.items = const [],
  });

  SavedOrder copyWith({
    String? id,
    String? name,
    String? notes,
    DateTime? orderDate,
    int? totalPieces,
    double? totalWeightKg,
    DateTime? createdAt,
    List<SavedOrderItem>? items,
  }) {
    return SavedOrder(
      id: id ?? this.id,
      name: name ?? this.name,
      notes: notes ?? this.notes,
      orderDate: orderDate ?? this.orderDate,
      totalPieces: totalPieces ?? this.totalPieces,
      totalWeightKg: totalWeightKg ?? this.totalWeightKg,
      createdAt: createdAt ?? this.createdAt,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    notes,
    orderDate,
    totalPieces,
    totalWeightKg,
    createdAt,
    items,
  ];
}

/// One product line inside a saved order.
class SavedOrderItem extends Equatable {
  final String id;
  final String orderId;
  final String? productId;
  final String productName;
  final int cartonCount;
  final int piecesPerBox;
  final int boxesPerCarton;
  final int totalPieces;
  final List<MaterialRequirement> materials;

  const SavedOrderItem({
    required this.id,
    required this.orderId,
    this.productId,
    required this.productName,
    required this.cartonCount,
    required this.piecesPerBox,
    required this.boxesPerCarton,
    required this.totalPieces,
    this.materials = const [],
  });

  @override
  List<Object?> get props => [
    id,
    orderId,
    productId,
    productName,
    cartonCount,
    piecesPerBox,
    boxesPerCarton,
    totalPieces,
    materials,
  ];
}
