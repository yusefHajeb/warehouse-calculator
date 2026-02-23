import 'dart:convert';
import '../../../calculator/domain/entities/calculation_result.dart';
import '../../domain/entities/saved_order.dart';

class SavedOrderModel extends SavedOrder {
  const SavedOrderModel({
    required super.id,
    required super.name,
    super.notes,
    required super.orderDate,
    required super.totalPieces,
    required super.totalWeightKg,
    required super.createdAt,
    super.items,
  });

  factory SavedOrderModel.fromEntity(SavedOrder entity) => SavedOrderModel(
    id: entity.id,
    name: entity.name,
    notes: entity.notes,
    orderDate: entity.orderDate,
    totalPieces: entity.totalPieces,
    totalWeightKg: entity.totalWeightKg,
    createdAt: entity.createdAt,
    items: entity.items,
  );

  /// Build from a row in the `saved_orders` table.
  /// Items are not included — they are loaded separately and attached via [withItems].
  factory SavedOrderModel.fromMap(Map<String, dynamic> map) => SavedOrderModel(
    id: map['id'] as String,
    name: map['name'] as String,
    notes: map['notes'] as String?,
    orderDate: DateTime.fromMillisecondsSinceEpoch(map['order_date'] as int),
    totalPieces: map['total_pieces'] as int,
    totalWeightKg: (map['total_weight_kg'] as num).toDouble(),
    createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
  );

  SavedOrderModel withItems(List<SavedOrderItem> items) => SavedOrderModel(
    id: id,
    name: name,
    notes: notes,
    orderDate: orderDate,
    totalPieces: totalPieces,
    totalWeightKg: totalWeightKg,
    createdAt: createdAt,
    items: items,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'notes': notes,
    'order_date': orderDate.millisecondsSinceEpoch,
    'total_pieces': totalPieces,
    'total_weight_kg': totalWeightKg,
    'created_at': createdAt.millisecondsSinceEpoch,
  };
}

class SavedOrderItemModel extends SavedOrderItem {
  const SavedOrderItemModel({
    required super.id,
    required super.orderId,
    super.productId,
    required super.productName,
    required super.cartonCount,
    required super.piecesPerBox,
    required super.boxesPerCarton,
    required super.totalPieces,
    super.materials,
  });

  factory SavedOrderItemModel.fromMap(Map<String, dynamic> map) {
    final materialsRaw = jsonDecode(map['materials_json'] as String) as List;
    final materials = materialsRaw
        .map(
          (m) => MaterialRequirement(
            ingredientId: m['ingredientId'] as String? ?? '',
            ingredientName: m['name'] as String,
            perPieceGrams: (m['perPieceGrams'] as num).toDouble(),
            requiredKg: (m['requiredKg'] as num).toDouble(),
          ),
        )
        .toList();

    return SavedOrderItemModel(
      id: map['id'] as String,
      orderId: map['order_id'] as String,
      productId: map['product_id'] as String?,
      productName: map['product_name'] as String,
      cartonCount: map['carton_count'] as int,
      piecesPerBox: map['pieces_per_box'] as int,
      boxesPerCarton: map['boxes_per_carton'] as int,
      totalPieces: map['total_pieces'] as int,
      materials: materials,
    );
  }

  Map<String, dynamic> toMap() {
    final materialsJson = jsonEncode(
      materials
          .map(
            (m) => {
              'ingredientId': m.ingredientId,
              'name': m.ingredientName,
              'perPieceGrams': m.perPieceGrams,
              'requiredKg': m.requiredKg,
            },
          )
          .toList(),
    );

    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'product_name': productName,
      'carton_count': cartonCount,
      'pieces_per_box': piecesPerBox,
      'boxes_per_carton': boxesPerCarton,
      'total_pieces': totalPieces,
      'materials_json': materialsJson,
    };
  }
}
