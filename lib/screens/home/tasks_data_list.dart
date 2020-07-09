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
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 0),
            child: Text("Tasks for Group",
              style: TextStyle(fontSize: 12.5),),
          ),
          Text("(specific to logged in user now)",
            style: TextStyle(fontSize: 12.5),),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: tasksData.length,
            itemBuilder: (context, index) {
              return TaskDataTile(taskData: tasksData[index]);
            },
          ),
        ],
      ),
    );
  }
}
