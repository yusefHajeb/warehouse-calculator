import 'package:uuid/uuid.dart';
import '../../../../core/database/database_helper.dart';
import '../models/saved_order_model.dart';

abstract class OrderLocalDataSource {
  Future<void> saveOrder(SavedOrderModel order);
  Future<List<SavedOrderModel>> getOrders();
  Future<SavedOrderModel> getOrderById(String id);
  Future<void> deleteOrder(String id);
}

class OrderLocalDataSourceImpl implements OrderLocalDataSource {
  final DatabaseHelper databaseHelper;

  OrderLocalDataSourceImpl({required this.databaseHelper});

  static const _uuid = Uuid();

  @override
  Future<void> saveOrder(SavedOrderModel order) async {
    final db = await databaseHelper.database;
    await db.transaction((txn) async {
      await txn.insert('saved_orders', order.toMap());
      for (final item in order.items) {
        final itemModel = SavedOrderItemModel(
          id: _uuid.v4(),
          orderId: order.id,
          productId: item.productId,
          productName: item.productName,
          cartonCount: item.cartonCount,
          piecesPerBox: item.piecesPerBox,
          boxesPerCarton: item.boxesPerCarton,
          totalPieces: item.totalPieces,
          materials: item.materials,
        );
        await txn.insert('saved_order_items', itemModel.toMap());
      }
    });
  }

  @override
  Future<List<SavedOrderModel>> getOrders() async {
    final db = await databaseHelper.database;
    final rows = await db.query('saved_orders', orderBy: 'created_at DESC');
    return rows.map((r) => SavedOrderModel.fromMap(r)).toList();
  }

  @override
  Future<SavedOrderModel> getOrderById(String id) async {
    final db = await databaseHelper.database;
    final orderRows = await db.query('saved_orders', where: 'id = ?', whereArgs: [id]);
    if (orderRows.isEmpty) throw Exception('Order not found: $id');

    final order = SavedOrderModel.fromMap(orderRows.first);
    final itemRows = await db.query('saved_order_items', where: 'order_id = ?', whereArgs: [id]);
    final items = itemRows.map((r) => SavedOrderItemModel.fromMap(r)).toList();
    return order.withItems(items);
  }

  @override
  Future<void> deleteOrder(String id) async {
    final db = await databaseHelper.database;
    await db.delete('saved_orders', where: 'id = ?', whereArgs: [id]);
  }
}
