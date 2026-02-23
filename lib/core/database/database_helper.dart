import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _dbName = 'product_management.db';
  static const _dbVersion = 3;

  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // ── Schema for fresh installs (v2) ─────────────────────────────────────────

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        pieces_per_box INTEGER NOT NULL,
        boxes_per_carton INTEGER NOT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE ingredients (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE product_ingredients (
        product_id TEXT NOT NULL,
        ingredient_id TEXT NOT NULL,
        grams_per_piece REAL NOT NULL,
        PRIMARY KEY (product_id, ingredient_id),
        FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
        FOREIGN KEY (ingredient_id) REFERENCES ingredients(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE saved_orders (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        notes TEXT,
        order_date INTEGER NOT NULL,
        total_pieces INTEGER NOT NULL,
        total_weight_kg REAL NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE saved_order_items (
        id TEXT PRIMARY KEY,
        order_id TEXT NOT NULL,
        product_id TEXT,
        product_name TEXT NOT NULL,
        carton_count INTEGER NOT NULL,
        pieces_per_box INTEGER NOT NULL,
        boxes_per_carton INTEGER NOT NULL,
        total_pieces INTEGER NOT NULL,
        materials_json TEXT NOT NULL,
        FOREIGN KEY (order_id) REFERENCES saved_orders(id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _migrateV1ToV2(db);
    }
    if (oldVersion < 3) {
      await _migrateV2ToV3(db);
    }
  }

  Future<void> _migrateV1ToV2(Database db) async {
    // 1. Create the two new tables.
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ingredients (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL UNIQUE
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS product_ingredients (
        product_id TEXT NOT NULL,
        ingredient_id TEXT NOT NULL,
        grams_per_piece REAL NOT NULL,
        PRIMARY KEY (product_id, ingredient_id),
        FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
        FOREIGN KEY (ingredient_id) REFERENCES ingredients(id)
      )
    ''');

    // 2. Read all existing product rows (still have the blob column).
    final productRows = await db.rawQuery('SELECT id, ingredients FROM products');

    // Map ingredient name (lower-cased) → id, populated as we go.
    final Map<String, String> ingredientNameToId = {};

    for (final row in productRows) {
      final productId = row['id'] as String;
      final blob = row['ingredients'];
      if (blob == null) continue;

      final List<dynamic> ingList = blob is String ? jsonDecode(blob) as List : blob as List;

      for (final rawIng in ingList) {
        final Map<String, dynamic> ingMap = rawIng as Map<String, dynamic>;
        final String name = (ingMap['name'] as String? ?? '').trim();
        final double gramsPerPiece = (ingMap['quantity_per_piece'] as num? ?? 0).toDouble();
        final String originalId = ingMap['id'] as String? ?? '';

        if (name.isEmpty) continue;

        final lowerName = name.toLowerCase();
        String ingredientId;

        if (ingredientNameToId.containsKey(lowerName)) {
          // Ingredient already upserted from a previous product — reuse its id.
          ingredientId = ingredientNameToId[lowerName]!;
        } else {
          // First time we see this ingredient name — use original id if valid.
          ingredientId = originalId.isNotEmpty ? originalId : _uuid();
          ingredientNameToId[lowerName] = ingredientId;

          await db.insert('ingredients', {
            'id': ingredientId,
            'name': name,
          }, conflictAlgorithm: ConflictAlgorithm.ignore);
        }

        await db.insert('product_ingredients', {
          'product_id': productId,
          'ingredient_id': ingredientId,
          'grams_per_piece': gramsPerPiece,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }

    // 3. Recreate products table WITHOUT the ingredients column.
    await db.execute('''
      CREATE TABLE products_new (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        pieces_per_box INTEGER NOT NULL,
        boxes_per_carton INTEGER NOT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      INSERT INTO products_new (id, name, pieces_per_box, boxes_per_carton, created_at, updated_at)
      SELECT id, name, pieces_per_box, boxes_per_carton, created_at, updated_at FROM products
    ''');
    await db.execute('DROP TABLE products');
    await db.execute('ALTER TABLE products_new RENAME TO products');
  }

  Future<void> _migrateV2ToV3(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS saved_orders (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        notes TEXT,
        order_date INTEGER NOT NULL,
        total_pieces INTEGER NOT NULL,
        total_weight_kg REAL NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS saved_order_items (
        id TEXT PRIMARY KEY,
        order_id TEXT NOT NULL,
        product_id TEXT,
        product_name TEXT NOT NULL,
        carton_count INTEGER NOT NULL,
        pieces_per_box INTEGER NOT NULL,
        boxes_per_carton INTEGER NOT NULL,
        total_pieces INTEGER NOT NULL,
        materials_json TEXT NOT NULL,
        FOREIGN KEY (order_id) REFERENCES saved_orders(id) ON DELETE CASCADE
      )
    ''');
  }

  // ── Simple UUID v4 generator (no package dependency) ──────────────────────
  static String _uuid() {
    final now = DateTime.now().microsecondsSinceEpoch;
    return 'mig-$now-${_rand()}';
  }

  static int _random = 0;
  static int _rand() => (_random = (_random + 1) % 100000);

  // ── Helpers ────────────────────────────────────────────────────────────────

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }

  Future<void> deleteDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    await deleteDatabase(path);
    _database = null;
  }
}
