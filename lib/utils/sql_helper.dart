import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper{

  static Future<void> createTable(sql.Database database) async{
    await database.execute(""" CREATE TABLE courses(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    title TEXT,
    description TEXT,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
    """);
  }

  //open database
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'myDatabase.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTable(database);
      },
    );
  }

  //create item
  static Future<int> createItem(String title, String? des) async {
    final db = await SQLHelper.db();

    final data = {'title': title, 'description': des};
    final id = await db.insert('courses', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  //get all records
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('courses', orderBy: "id");
  }

  //get single item
  static Future<List<Map<String, dynamic>>> getSingleItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('courses', where: "id = ?", whereArgs: [id], limit: 1);
  }


  // Update an item by id
  static Future<int> updateItem(int id, String title, String? des) async {
    final db = await SQLHelper.db();

    final data = {
      'title': title,
      'description': des,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('courses', data, where: "id = ?", whereArgs: [id]);
    return result;
  }


  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("courses", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}