import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/ingredient.dart';
import '../models/ingredient_model.dart';
import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel?> getProductById(String id);
  Future<List<ProductModel>> searchProducts(String query);
  Future<void> addProduct(ProductModel product);
  Future<void> updateProduct(ProductModel product);
  Future<void> deleteProduct(String id);

  // ── Ingredient catalogue ─────────────────────────────────────────────────
  Future<List<IngredientModel>> getAllIngredients();
  Future<IngredientModel> upsertIngredient(String name);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final DatabaseHelper databaseHelper;

  ProductLocalDataSourceImpl({required this.databaseHelper});

  // ─────────────────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────────────────

  /// Loads the ingredient list for a single product via JOIN.
  Future<List<IngredientModel>> _loadIngredients(Database db, String productId) async {
    final rows = await db.rawQuery(
      '''
      SELECT i.id, i.name, pi.grams_per_piece
      FROM ingredients i
      JOIN product_ingredients pi ON i.id = pi.ingredient_id
      WHERE pi.product_id = ?
    ''',
      [productId],
    );
    return rows.map(IngredientModel.fromJoinRow).toList();
  }

  /// Writes ingredient links for a product inside an existing transaction.
  /// Existing links for this product are cleared first.
  Future<void> _writeIngredientLinks(
    DatabaseExecutor txn,
    String productId,
    List<Ingredient> ingredients,
  ) async {
    // Remove old links.
    await txn.delete('product_ingredients', where: 'product_id = ?', whereArgs: [productId]);

    for (final ingredient in ingredients) {
      final model = IngredientModel.fromEntity(ingredient);

      // Upsert the canonical ingredient row (unique by name).
      await txn.insert(
        'ingredients',
        model.toIngredientMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );

      // Fetch the authoritative id (may differ if another row with same name existed).
      final existing = await txn.query(
        'ingredients',
        columns: ['id'],
        where: 'name = ?',
        whereArgs: [ingredient.name],
        limit: 1,
      );

      final canonicalId = existing.isNotEmpty ? existing.first['id'] as String : model.id;

      // Write the link with grams_per_piece.
      await txn.insert('product_ingredients', {
        'product_id': productId,
        'ingredient_id': canonicalId,
        'grams_per_piece': ingredient.quantityPerPiece,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Public: Products
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final db = await databaseHelper.database;
      final rows = await db.query('products', orderBy: 'created_at DESC');
      final List<ProductModel> result = [];
      for (final row in rows) {
        final id = row['id'] as String;
        final ingredients = await _loadIngredients(db, id);
        result.add(ProductModel.fromMap(row, ingredients: ingredients));
      }
      return result;
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
      final rows = await db.query('products', where: 'id = ?', whereArgs: [id]);
      if (rows.isEmpty) return null;
      final ingredients = await _loadIngredients(db, id);
      return ProductModel.fromMap(rows.first, ingredients: ingredients);
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
      final rows = await db.query(
        'products',
        where: 'name LIKE ?',
        whereArgs: ['%$query%'],
        orderBy: 'created_at DESC',
      );
      final List<ProductModel> result = [];
      for (final row in rows) {
        final id = row['id'] as String;
        final ingredients = await _loadIngredients(db, id);
        result.add(ProductModel.fromMap(row, ingredients: ingredients));
      }
      return result;
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
      await db.transaction((txn) async {
        await txn.insert('products', product.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
        await _writeIngredientLinks(txn, product.id, product.ingredients);
      });
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
      await db.transaction((txn) async {
        final count = await txn.update(
          'products',
          product.toMap(),
          where: 'id = ?',
          whereArgs: [product.id],
        );
        if (count == 0) {
          throw const NotFoundException(message: 'المنتج غير موجود للتحديث');
        }
        await _writeIngredientLinks(txn, product.id, product.ingredients);
      });
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
      // product_ingredients rows are removed via ON DELETE CASCADE.
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

  // ─────────────────────────────────────────────────────────────────────────
  // Public: Ingredient catalogue
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Future<List<IngredientModel>> getAllIngredients() async {
    try {
      final db = await databaseHelper.database;
      final rows = await db.query('ingredients', orderBy: 'name ASC');
      return rows.map(IngredientModel.fromIngredientRow).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw LocalDatabaseException(message: 'فشل في جلب المكونات', originalError: e);
    }
  }

  @override
  Future<IngredientModel> upsertIngredient(String name) async {
    try {
      final db = await databaseHelper.database;
      final trimmed = name.trim();

      // Case-insensitive lookup.
      final existing = await db.rawQuery(
        'SELECT id, name FROM ingredients WHERE LOWER(name) = LOWER(?) LIMIT 1',
        [trimmed],
      );
      if (existing.isNotEmpty) {
        return IngredientModel.fromIngredientRow(existing.first);
      }

      final id = const Uuid().v4();
      await db.insert('ingredients', {'id': id, 'name': trimmed});
      return IngredientModel(id: id, name: trimmed, quantityPerPiece: 0);
    } on AppException {
      rethrow;
    } catch (e) {
      throw LocalDatabaseException(message: 'فشل في حفظ المكوّن', originalError: e);
    }
  }
}
