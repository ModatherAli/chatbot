import 'dart:async';
import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../helper/logger_utils.dart';
import '../../modules/message.dart';

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
    "id" INTEGER,
    "message" TEXT,
    "is_ai" INTEGER)''');

    log('database created');
  }

  Future<List<Message>?> readData() async {
    List<Message>? messages;
    try {
      Database? db = await database;

      List<Map<String, Object?>> data = await db!.query('Messages');

      messages =
          data.map((map) => Message.fromJson(map)).toList().reversed.toList();

      log('read success');
    } catch (e) {
      Logger.print('error in read data :$e');
    }
    return messages;
  }

  Future<int> insertData(Message message) async {
    Database? db = await database;

    int? data = await db!.insert(
      'Messages',
      message.toJson(),
    );

    log('insert success $data');
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
