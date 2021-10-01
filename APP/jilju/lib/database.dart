import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'model.dart';

class DatabaseManager {
  static final DatabaseManager _instance = DatabaseManager._internal();
  late final Future<Database> _database;

  factory DatabaseManager() {
    return _instance;
  }

  DatabaseManager._internal() {
    _database = _openDatabase();
  }

  Future<Database> _openDatabase() async {
    return openDatabase(
      join('await getDatabasesPath()', 'database.db'),
      onCreate: (db, version) => _createTables(db),
      version: 1,
    );
  }

  Future<int> insertJilju(Jilju jilju) async {
    final Database db = await _database;
    return db.insert('jilju', jilju.toMap());
  }

  Future<int> insertJiljuPoint(JiljuPoint jiljuPoint) async {
    final Database db = await _database;
    return db.insert('jilju_point', jiljuPoint.toMap());
  }

  Future<int> getNextJiljuId() async {
    final Database db = await _database;
    var result =
        await db.query('SELECT IFNULL(MAX(jilju_id), 0) + 1 FROM jilju');
    return result.first.values.first as int;
  }

  Future<void> _createTables(Database db) async {
    await db.execute(
      'CREATE TABLE jilju('
      'jilju_id INTEGER PRIMARY KEY, '
      'start_time INTEGER NOT NULL, '
      'end_time INTEGER NOT NULL, '
      'distance REAL NOT NULL'
      ')',
    );
    await db.execute(
      'CREATE TABLE jilju_point('
      'jilju_point_id INTEGER PRIMARY KEY, '
      'jilju_id INTEGER NOT NULL, '
      'time INTEGER NOT NULL, '
      'x INTEGER NOT NULL, '
      'y INTEGER NOT NULL, '
      'FOREIGN KEY (jilju_id) REFERENCES jilju (jilju_id) '
      'ON UPDATE CASCADE ON DELETE CASCADE'
      ')',
    );
  }
}
