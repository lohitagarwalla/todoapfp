import 'package:flutter/material.dart';
import 'package:todoapp/taskinfo.dart';
import 'database_helper.dart';

DatabaseHelper helper = DatabaseHelper.instance;
List<TaskInfo> taskList = [];
int count = 0;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController textController = TextEditingController();
  String taskName;
  void updateList() async {
    taskList = await helper.getTaskList();
    setState(() {
      count = taskList.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    updateList();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.lightBlueAccent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 30, bottom: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30.0,
                    child: Icon(
                      Icons.list,
                      size: 30.0,
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Todoey',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        taskList.length.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        ' Tasks',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TileList(),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textController,
                      onChanged: (value) {
                        taskName = value;
                      },
//                    controller: messageTextController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(40.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(40.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0)),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        hintText: 'Type a new task here...',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    color: Colors.blue,
                    onPressed: () {
                      if (taskName != null) {
                        TaskInfo newTask = TaskInfo(taskName, 0);
                        helper.insert(newTask);
                        updateList();
                        count = taskList.length;
                        setState(() {
                          textController.clear();
                        });
                        taskName = null;
                      }
                    },
                    child: Text(
                      'Add',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TileList extends StatefulWidget {
  @override
  _TileListState createState() => _TileListState();
}

class _TileListState extends State<TileList> {
  void updateList() async {
    taskList = await helper.getTaskList();
    setState(() {
      count = taskList.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (context, index) {
        return SingleTile(
          name: taskList[index].Name,
          isChecked: taskList[index].isdone,
          onChanged: (newValue) {
            TaskInfo newTask = TaskInfo.withId(taskList[index].myId,
                taskList[index].Name, taskList[index].isdone == 1 ? 0 : 1);
            helper.updateTask(newTask);
            updateList();
          },
          onLongPress: () {
            helper.deleteTask(taskList[index].myId);
            updateList();
            setState(() {
//              taskList.removeAt(index);
            });
          },
        );
      },
    );
  }
}

class SingleTile extends StatelessWidget {
  SingleTile({this.isChecked, this.name, this.onChanged, this.onLongPress});
  final int isChecked;
  final String name;
  final Function onChanged;
  final Function onLongPress;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: onLongPress,
      title: Text(
        name,
        style: TextStyle(
            decoration: isChecked == 1 ? TextDecoration.lineThrough : null,
            fontSize: isChecked == 1 ? 15.0 : 18.0),
      ),
      trailing: Checkbox(
          activeColor: Colors.lightBlueAccent,
          value: isChecked == 1,
          onChanged: onChanged),
    );
  }
}
