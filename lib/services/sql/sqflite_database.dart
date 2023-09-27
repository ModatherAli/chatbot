import 'dart:async';
import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlDatabase {
  Database? _database;

  Future<Database?> get database async {
    _database ??= await initial();
    return _database;
  }

  Future<Database> initial() async {
    String path = await getDatabasesPath();
    String dbName = 'database.db';
    String fullPath = join(path, dbName); //'$path/$dbName';
    Database database =
        await openDatabase(fullPath, onCreate: _onCreate, version: 1);
    return database;
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE "Messages"(
    "id" INTEGER PRIMARY KEY,
    "message" TEXT,
    "is_image" INTEGER,
    "is_ai" INTEGER)''');

    log('database created');
  }

  Future<List<Map<String, Object?>>> readData(String sql) async {
    Database? db = await database;

    List<Map<String, Object?>> data = await db!.rawQuery(sql);
    log('read success');
    return data;
  }

  Future<int> insertData(String sql) async {
    Database? db = await database;

    int data = await db!.rawInsert(sql);
    log('insert success $data');
    return data;
  }

  Future<int> updateData(String sql) async {
    Database? db = await database;

    int data = await db!.rawUpdate(sql);
    log('update success $data');
    return data;
  }

  Future<int> deleteData(String sql) async {
    Database? db = await database;

    int data = await db!.rawDelete(sql);
    log('delete success $data');
    return data;
  }

  deleteAll() async {
    String path = await getDatabasesPath();
    String dbName = 'database.db';
    String fullPath = '$path/$dbName';
    await deleteDatabase(fullPath);
    log('database deleted');
  }
}
