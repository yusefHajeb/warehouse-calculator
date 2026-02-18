import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/error/exceptions.dart';
import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel?> getProductById(String id);
  Future<List<ProductModel>> searchProducts(String query);
  Future<void> addProduct(ProductModel product);
  Future<void> updateProduct(ProductModel product);
  Future<void> deleteProduct(String id);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final DatabaseHelper databaseHelper;

  ProductLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query('products', orderBy: 'created_at DESC');
      return result.map((map) => ProductModel.fromMap(map)).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw LocalDatabaseException(message: 'فشل في جلب المنتجات', originalError: e);
    }
  }

  @override
  Future<ProductModel?> getProductById(String id) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query('products', where: 'id = ?', whereArgs: [id]);
      if (result.isEmpty) return null;
      return ProductModel.fromMap(result.first);
    } on AppException {
      rethrow;
    } catch (e) {
      throw LocalDatabaseException(message: 'فشل في جلب المنتج', originalError: e);
    }
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        'products',
        where: 'name LIKE ?',
        whereArgs: ['%$query%'],
        orderBy: 'created_at DESC',
      );
      return result.map((map) => ProductModel.fromMap(map)).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw LocalDatabaseException(message: 'فشل في البحث عن المنتجات', originalError: e);
    }
  }

  @override
  Future<void> addProduct(ProductModel product) async {
    try {
      final db = await databaseHelper.database;
      await db.insert('products', product.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    } on AppException {
      rethrow;
    } catch (e) {
      throw LocalDatabaseException(message: 'فشل في إضافة المنتج', originalError: e);
    }
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    try {
      final db = await databaseHelper.database;
      final count = await db.update(
        'products',
        product.toMap(),
        where: 'id = ?',
        whereArgs: [product.id],
      );
      if (count == 0) {
        throw const NotFoundException(message: 'المنتج غير موجود للتحديث');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw LocalDatabaseException(message: 'فشل في تحديث المنتج', originalError: e);
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      final db = await databaseHelper.database;
      final count = await db.delete('products', where: 'id = ?', whereArgs: [id]);
      if (count == 0) {
        throw const NotFoundException(message: 'المنتج غير موجود للحذف');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw LocalDatabaseException(message: 'فشل في حذف المنتج', originalError: e);
    }
  }
}
