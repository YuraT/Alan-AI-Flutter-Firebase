import 'package:flutter/material.dart';
import 'package:project1/models/user.dart';
import 'package:project1/screens/home/task_data_tile.dart';
import 'package:provider/provider.dart';

class TasksDataList extends StatefulWidget {
  TasksDataList({Key tasksDataKey}) : super(key: tasksDataKey);
  @override
  TasksDataListState createState() => TasksDataListState();
}

class TasksDataListState extends State<TasksDataList> {
  List<TaskDataModel> currentTasksData;

  @override
  Widget build(BuildContext context) {
    final tasksData = Provider.of<List<TaskDataModel>>(context) ?? [];
    setState(() {
      currentTasksData = tasksData;
    });

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