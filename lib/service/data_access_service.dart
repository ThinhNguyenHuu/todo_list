import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/models/todo_dto.dart';

class DataAccessService {
  static final DataAccessService _dataAccessService = DataAccessService._internal();

  factory DataAccessService() {
    return _dataAccessService;
  }

  DataAccessService._internal();

  Database? _database;

  Future<void> open() async {
    _database = await openDatabase(join(await getDatabasesPath(), 'todo_list.db'), version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Todos(id INTEGER PRIMARY KEY, taskName TEXT, description TEXT, time TEXT, hasNotification INTEGER, scheduledNotificationAt TEXT)');
    });
  }

  Future<void> close() async {
    await _database?.close();
  }

  Future<void> insertTodo(TodoDTO todo) async {
    await open();
    await _database?.insert('Todos', todo.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    await close();
  }

  Future<List<TodoDTO>> retrieveTodos() async {
    await open();
    final List<Map<String, dynamic>>? maps = await _database?.query('Todos');
    await close();

    return List.generate(maps!.length, (i) {
      return TodoDTO(
        id: maps[i]['id'],
        taskName: maps[i]['taskName'],
        description: maps[i]['description'],
        time: DateTime.parse(maps[i]['time']),
        hasNotification: maps[i]['hasNotification'] == 1,
        scheduledNotificationAt: DateTime.parse(maps[i]['scheduledNotificationAt']),
      );
    });
  }

  Future<void> deleteTodos(List<int> ids) async {
    await open();
    for (var i = 0; i < ids.length; i++) {
      await _database?.delete('Todos', where: 'id = ?', whereArgs: [ids[i]]);
    }
    await close();
  }
}
