import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'users.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE users(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          username TEXT NOT NULL,
          password TEXT NOT NULL,
          gender TEXT
        )
      ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE users ADD COLUMN gender TEXT');
        }
      },
    );
  }

  Future<int> registerUser(
    String name,
    String username,
    String password, {
    String? gender,
  }) async {
    final dbClient = await db;
    return await dbClient.insert('users', {
      'name': name,
      'username': username,
      'password': password,
      'gender': gender,
    });
  }

  Future<Map<String, dynamic>?> loginUser(
    String username,
    String password,
  ) async {
    final dbClient = await db;
    final result = await dbClient.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<Map<String, dynamic>?> getUserById(int id) async {
    final dbClient = await db;
    final result = await dbClient.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateUser(
    int id,
    String name,
    String username,
    String? password,
  ) async {
    final dbClient = await db;
    Map<String, dynamic> values = {'name': name, 'username': username};
    if (password != null && password.isNotEmpty) {
      values['password'] = password;
    }
    return await dbClient.update(
      'users',
      values,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
