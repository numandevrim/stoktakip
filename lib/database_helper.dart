import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  
  static Future<Database> getDatabase() async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDatabase();
      return _database!;
    }
  }

  
  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'products.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE products(
            urunid INTEGER PRIMARY KEY,
            urunad TEXT,
            alisfiyati INTEGER,
            satisfiyati INTEGER,
            stok INTEGER
          )
        ''');
      },
    );
  }

  
  static Future<void> insertProduct(Map<String, dynamic> product) async {
    final db = await getDatabase();
    await db.insert(
      'products',
      {
        'urunad': product['urunad'],
        'alisfiyati': product['alisfiyati'],
        'satisfiyati': product['satisfiyati'],
        'stok': product['stok'],
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> deleteProduct(String urunad) async {
    final db = await getDatabase();

    try {
      await db.delete(
        'products',
        where: 'urunad = ?',
        whereArgs: [urunad],
      );
    } catch (e) {
      print("Ürün silerken hata: $e");
    }
  }

  
  static Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await getDatabase();
    return await db.query('products');
  }
}
