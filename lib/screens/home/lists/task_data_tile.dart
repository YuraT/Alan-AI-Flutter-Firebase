import 'package:flutter/material.dart';
import 'package:project1/models/user.dart';
import 'package:project1/models/user_data_model.dart';
import 'package:provider/provider.dart';

class TaskDataTile extends StatelessWidget {
  final TaskDataModel taskData;
  TaskDataTile({this.taskData});
  
  @override
  Widget build(BuildContext context) {
    List<UserDataModel> users = Provider.of<List<UserDataModel>>(context);
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text("Task: ${taskData.title}"),
              subtitle: Text("Desc: ${taskData.description}, \nassigner: ${users.singleWhere((user) => user.uid == taskData.assigner).username}, \nusers: ${users.where((user) => taskData.users.contains(user.uid)).map((user) => user.username)}, \ndeadline:${taskData.deadline}"),
            ),
          ],
        ),
      ),
    );
  }
}