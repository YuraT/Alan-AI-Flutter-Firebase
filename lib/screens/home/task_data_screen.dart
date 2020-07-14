import 'package:flutter/material.dart';
import 'package:project1/services/database.dart';
import 'package:project1/shared/constants.dart';
import 'package:project1/models/user.dart';
import 'package:project1/models/user_data_model.dart';
import 'package:provider/provider.dart';

class TaskDataScreen extends StatefulWidget {
  final TaskDataModel taskData;

  TaskDataScreen({
    Key taskDataScreenKey,
    @required this.taskData,
  }) : super(key: taskDataScreenKey);
  @override
  TaskDataScreenState createState() => TaskDataScreenState();
}

class TaskDataScreenState extends State<TaskDataScreen> {
  TaskDataModel currentTaskData;

  @override
  Widget build(BuildContext context) {
    setState(() {
      currentTaskData = widget.taskData; 
    });
    final List<UserDataModel> _allUsers = Provider.of<List<UserDataModel>>(context);
    final List<UserDataModel> _taskUsers = _allUsers.where((user) => currentTaskData.users.contains( user.uid)).toList();

    return Scaffold(
      backgroundColor: c,
      appBar: AppBar(
        title: Text(currentTaskData.title),
        backgroundColor: a,
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.check),
            label: Text("Complete Task"),
            onPressed: () => {
              DatabaseService().updateTaskData(
                currentTaskData.uid, 
                {"completedStatus" : true}
              ).then((val) => {
                Navigator.pop(context)
              })
            },
          ),
        ],
      ),

      body: Column(
        children: <Widget>[
          Text(currentTaskData.description),
          Text("completed: ${currentTaskData.completedStatus}"),
          Text("deadline: ${currentTaskData.deadline}"),
          Text("assigner: ${_allUsers.singleWhere((user) => user.uid == currentTaskData.assigner).username}"),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _taskUsers.length,
            itemBuilder: (context, index) {
              return Text("user $index: ${_taskUsers[index].username}");
            },
          ),
        ],
      )
    );
  }
}
