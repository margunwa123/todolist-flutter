import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:todo_app/Common/todo.dart';

class TodoController {
  late final Future<Database> _db = _getDatabase();
  final tableName = "todos";

  // The controller is a singleton
  static final TodoController _instance = TodoController._internal();

  factory TodoController() {
    return _instance;
  }

  TodoController._internal();

  Future<List<Todo>> todos({
    bool archived = false,
    bool? favorites = null
  }) async {
    String builder = '''
      SELECT * FROM $tableName 
      WHERE done = ${archived ? 1 : 0}
    ''';

    if(favorites != null) {
      builder += " AND favorite = ${favorites ? 1 : 0}";
    }

    builder += " ORDER BY favorite DESC";

    List<Map<String, dynamic>> todos = await ((await _db).rawQuery(
      builder 
    ));

    return List.generate(todos.length, (index) {
      final todoItem = todos[index];
      final isFavorite = todoItem['favorite'] == 0 ? false : true;
      final isDone = todoItem['done'] == 0 ? false : true;
      return Todo(
        id: todoItem['id'], 
        name: todoItem['name'], 
        favorite: isFavorite, 
        done: isDone
      );
    });
  }
  
  Future<int> deleteById(int id) async {
    return (await _db).delete(tableName, where: "id = ?", whereArgs: [id]);
  }

  Future<int> insertTodo(Todo todo) async {
    return (await _db).insert(tableName, todo.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateTodo(Todo todo) async {
    return (await _db).update(tableName, todo.toMap(), where: "id = ?", whereArgs: [todo.id]);
  }

  Future<Database> _getDatabase() async {
    final createQuery = 
      """
        CREATE TABLE $tableName (
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          name TEXT,
          favorite INTEGER,
          done INTEGER
        )
      """;
    final dropQuery = "DROP TABLE $tableName";
    
    return openDatabase(
      // set the database path
      join(await getDatabasesPath(), 'todo_database.db'),

      // create the todo db on wake
      onCreate: ((db, version) => db.execute(
        createQuery
      )),
      onUpgrade: (db, oldVer, newVer) {
        db.execute(dropQuery);
        db.execute(createQuery);
      },
      // the version will be the one to determine the oncreate
      // is executed or not
      version: 1
    );
  }

  Future<void> toggleFavorite(Todo todo) async {
    todo.favorite = !todo.favorite;
    (await _db).update(tableName, todo.toMap(), where: "id = ?", whereArgs: [todo.id]);
  }

  Future<void> toggleDone(Todo todo) async {
    todo.done = !todo.done;
    
    (await _db).update(tableName, todo.toMap(), where: "id = ?", whereArgs: [todo.id]);
  }

  Future<void> delete({ bool? archived = null }) async {
    String queryBuilder = 'DELETE FROM $tableName';

    if(archived != null) {
      queryBuilder += " WHERE done = ${archived ? 1 : 0}";
    }

    (await _db).rawQuery(queryBuilder);
  }
}