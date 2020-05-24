import 'package:flutter/material.dart';
import 'package:project1/models/user.dart';

class TaskDataTile extends StatelessWidget {
  final TaskDataModel taskData;
  TaskDataTile({this.taskData});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text("Task: ${taskData.title}"),
              subtitle: Text("Desc: ${taskData.description}, \nassigner: ${taskData.assigner}, \nusers: ${taskData.users}, \ndeadline:${taskData.deadline}"),
            ),
          ],
        ),
      ),
    );
  }
}