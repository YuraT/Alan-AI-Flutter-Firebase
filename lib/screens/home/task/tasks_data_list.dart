import 'package:flutter/material.dart';
import 'package:project1/models/group_data_model.dart';
import 'package:project1/models/task_data_model.dart';
import 'package:project1/models/user.dart';
import 'package:project1/screens/home/task/task_data_tile.dart';
import 'package:project1/screens/wrapper.dart';
import 'package:provider/provider.dart';

class TasksDataList extends StatefulWidget {
  final bool completed;
  final GroupDataModel group;
  TasksDataList({Key tasksDataKey, this.completed, this.group}) : super(key: tasksDataKey);
  @override
  TasksDataListState createState() => TasksDataListState();
}

class TasksDataListState extends State<TasksDataList> {
  List<TaskDataModel> currentTasksData;
  List<TaskDataModel> currentUncompletedTasksData;
  List<TaskDataModel> currentCompletedTasksData;

  @override
  Widget build(BuildContext context) {
    final tasksData = Provider.of<List<TaskDataModel>>(context).where((task) => task.group == widget.group.ref).toList() ?? [];
    setState(() {
      currentTasksData = widget.group.admins.contains(Provider.of<User>(context).ref)? tasksData : tasksData.where((task) => (task.users.contains(Provider.of<User>(context).ref) || task.assigner == Provider.of<User>(context).ref)).toList();
      currentUncompletedTasksData = currentTasksData.where((task) => !task.completedStatus).toList();
      currentCompletedTasksData = currentTasksData.where((task) => task.completedStatus).toList();
      Wrapper.setVisuals(context);
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
            style: TextStyle(
              fontSize: 12.5,
              height: 5.0,
            )
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: currentUncompletedTasksData.length,
            itemBuilder: (context, index) {
              return TaskDataTile(taskData: currentUncompletedTasksData[index]);
            },
          ),
          Text("(Completed Tasks)",
            style: TextStyle(
              fontSize: 12.5,
              height: 5.0,
            ),
          ),
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
