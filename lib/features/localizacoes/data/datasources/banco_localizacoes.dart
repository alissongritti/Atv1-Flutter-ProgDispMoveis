import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class BancoLocalizacoes {
  static Database? _db;

  static Future<Database> get instance async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  static Future<Database> _initDatabase() async {
    final path = p.join(await getDatabasesPath(), 'localizacoes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE localizacoes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            latitude REAL NOT NULL,
            longitude REAL NOT NULL,
            precisao REAL NOT NULL,
            instante TEXT NOT NULL
          )
        '''); //
      },
    );
  }
}