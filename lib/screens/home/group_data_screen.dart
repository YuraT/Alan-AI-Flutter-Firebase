import 'package:flutter/material.dart';
import 'package:project1/models/group_data_model.dart';
import 'package:project1/models/user.dart';
import 'package:project1/services/database.dart';
import 'package:provider/provider.dart';
import 'package:project1/screens/home/tasks_data_list.dart';

class GroupDataScreen extends StatelessWidget {
  final GroupDataModel groupData;
  GroupDataScreen({this.groupData});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<TaskDataModel>>.value(
      value: DatabaseService(group: groupData.uid).tasks,
      child: Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text(groupData.name),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
          ),
      body: 
        TasksDataList(),
      )
    );
  }
}