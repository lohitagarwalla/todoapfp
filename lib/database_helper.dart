import 'taskinfo.dart';
import 'package:sqflite/sqflite.dart';

String id = '_id';
String name = '_name';
String isDone = '_isDone';

class DatabaseHelper {
  static final _databaseName = "TaskInfo.db";
  static final _databaseVersion = 1;
  final String tableName = 'mytable';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await _createDatabase();
    return _database;
  }

  _createDatabase() async {
    var databasePath = await getDatabasesPath();
    var path = databasePath + _databaseName;

    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(database, int version) async {
    await database.execute(
        'CREATE TABLE $tableName($id INTEGER PRIMARY KEY, $name TEXT, $isDone INTEGER)');
  }

  Future<int> insert(TaskInfo taskInfo) async {
    Database db = await database;
    var result = await db.insert(tableName, taskInfo.toMap());
    return result;
  }

  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    Database db = await this.database;
//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.query(tableName);
    return result;
  }

  Future<List<TaskInfo>> getTaskList() async {
    var taskMapList = await getTaskMapList();
    List<TaskInfo> taskList = [];
    int count = taskMapList.length;
    for (int i = 0; i < count; i++) {
      TaskInfo taskInfo = TaskInfo.mapToObject(taskMapList[i]);
      taskList.insert(0, taskInfo);
    }
    return taskList;
  }

  Future<int> deleteTask(int _id) async {
    Database db = await database;
    int result = await db.rawDelete('DELETE FROM $tableName WHERE $id = $_id');
    return result;
  }

  Future<int> updateTask(TaskInfo taskInfo) async {
    Database db = await database;
    var result = await db.update(tableName, taskInfo.toMap(),
        where: '$id = ?', whereArgs: [taskInfo.myId]);
    return result;
  }
}
