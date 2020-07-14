import 'package:flutter/material.dart';
import 'package:project1/models/user.dart';
import 'package:project1/screens/home/task_data_tile.dart';
import 'package:provider/provider.dart';

class TasksDataList extends StatefulWidget {
  final bool completed;
  TasksDataList({Key tasksDataKey, this.completed}) : super(key: tasksDataKey);
  @override
  TasksDataListState createState() => TasksDataListState();
}

class TasksDataListState extends State<TasksDataList> {
  List<TaskDataModel> currentTasksData;
  List<TaskDataModel> currentUncompletedTasksData;
  List<TaskDataModel> currentCompletedTasksData;

  @override
  Widget build(BuildContext context) {
    final tasksData = Provider.of<List<TaskDataModel>>(context) ?? [];
    setState(() {
      currentTasksData = tasksData;
      currentUncompletedTasksData = currentTasksData.where((task) => !task.completedStatus).toList();
      currentCompletedTasksData = currentTasksData.where((task) => task.completedStatus).toList();
    });
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 0),
            child: Text("Tasks for Group",
              style: TextStyle(fontSize: 12.5),),
          ),
          Text("(Uncompleted Tasks)",
            style: TextStyle(fontSize: 12.5),),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: currentUncompletedTasksData.length,
            itemBuilder: (context, index) {
              return TaskDataTile(taskData: currentUncompletedTasksData[index]);
            },
          ),
          Text("(Completed Tasks)",
            style: TextStyle(fontSize: 12.5),),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: currentCompletedTasksData.length,
            itemBuilder: (context, index) {
              return TaskDataTile(taskData: currentCompletedTasksData[index]);
            },
          ),
        ],
      ),
    );
  }
}
