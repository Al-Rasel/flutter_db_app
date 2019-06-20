import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'SQLHelper.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE $tableTodo ("
          "$columnId INTEGER PRIMARY KEY,"
          "$columnTitle TEXT,"
          "$columnDateTime TEXT"
          ")");
    });
  }

  Future<Todo> insertNote(Todo todo) async {
    todo.id = await database.then((db) {
      try {
        db.insert(tableTodo, todo.toMap());
      } catch (e) {
        print(e);
      }
    });

    return todo;
  }

  /* tableTodo,
          columns: [columnId, columnTitle, columnDateTime],
          where: '$columnId = ?',
          whereArgs: [id]);*/

  Future<Todo> getTodo(int id) async {
    List<Map> maps = await database.then((db) {
      db.query(
        tableTodo,
        columns: [columnId, columnTitle, columnDateTime],
        where: '$columnId = ?',
        whereArgs: [id],
      );
    });

    if (maps.length > 0) {
      return Todo.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Todo>> getAllList() async {
    List<Map> maps = await database.then((db) {
      db.query(tableTodo);
    });

    return maps.map((todo) {
      Todo.fromMap(todo);
    }).toList();
  }
}
