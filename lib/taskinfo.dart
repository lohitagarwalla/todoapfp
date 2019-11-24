String id = '_id';
String name = '_name';
String isDone = '_isDone';

class TaskInfo {
  int _id;
  String _name;
  int _isDone;

  TaskInfo(this._name, this._isDone);
  TaskInfo.withId(this._id, this._name, this._isDone);

  int get myId => _id;
  String get Name => _name;
  int get isdone => _isDone;

//  TaskInfo({this.name, this.isDone = false});
//  void toggleIsDone() {
//    isDone = !isDone;
//  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map[name] = _name;
    map[isDone] = _isDone;
    return map;
  }

  TaskInfo.mapToObject(Map<String, dynamic> taskInfo) {
    _id = taskInfo[id];
    _name = taskInfo[name];
    _isDone = taskInfo[isDone];
  }
}
