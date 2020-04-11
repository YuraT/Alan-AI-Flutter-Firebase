import 'package:flutter/material.dart';
import 'package:project1/models/user.dart';
import 'package:project1/screens/home/task_data_tile.dart';
import 'package:provider/provider.dart';

class TasksDataList extends StatefulWidget {
  @override
  _TasksDataListState createState() => _TasksDataListState();
}

class _TasksDataListState extends State<TasksDataList> {
  @override
  Widget build(BuildContext context) {
    final tasksData = Provider.of<List<TaskDataModel>>(context) ?? [];
    /*tasksData.forEach((taskData) {
      print(taskData.title);
      print(taskData.description);
      print(taskData.users);
    });*/

    return Column(
      children: <Widget>[
        Text("Tasks for Group"),
        Text("(specific to logged in user now)"),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: tasksData.length,
          itemBuilder: (context, index) {
            return TaskDataTile(taskData: tasksData[index]);
          },
        ),
      ],
    );
  }
}