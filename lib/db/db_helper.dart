import 'dart:developer';

import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

// Database 다시 정리할 것
class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = "tasks";

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }

    try {
      String _path = await getDatabasesPath() + "tasks.db";
      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: (db, version) {
          return db.execute('''
CREATE TABLE [if not exist] $_tableName(
id INTEGER PRIMARY KEY AUTOINCREMENT, 
title String, 
note TEXT, 
date String,
startTime String, 
endTime String, 
remind integer, 
repeat String, 
color INTEGER,
isCompleted INTEGER)
          ''');
        },
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insert(Task? task) async {
    log("insert function called");
    return await _db?.insert(_tableName, task!.toJson()) ?? 1;
  }
  // null exception 있음
  static Future<List<Map<String, dynamic>>> query() async {
    print("query function called");
    return await _db!.query(_tableName);
  }

  static delete(Task task) async {
    return await _db!.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  static update(int id) async {
    return await _db!.rawUpdate(
      "UPDATE tasks SET isCompleted = ?  WHERE id = ?",
      [1, id],
    );
  }

  static Future<void> getOne(Task task) async {
    await _db!.query(_tableName, where: 'id=?', whereArgs: [task.id]);
  }
}
