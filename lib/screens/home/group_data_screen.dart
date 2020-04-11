import 'package:flutter/material.dart';
import 'package:project1/models/group_data_model.dart';
import 'package:project1/models/user.dart';
import 'package:project1/screens/home/task_add_form.dart';
import 'package:project1/services/database.dart';
import 'package:provider/provider.dart';
import 'package:project1/screens/home/tasks_data_list.dart';

class GroupDataScreen extends StatelessWidget {
  final GroupDataModel groupData;
  GroupDataScreen({this.groupData});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    void _showTaskAddPanel() {
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: TaskAddForm(groupData: groupData,),
        );
      });
    }
    return StreamProvider<List<TaskDataModel>>.value(
      // userUid is only specified if the user is not included in the admins list of the group, who should be able to see all tasks
      value: DatabaseService(groupUid: groupData.uid, userUid: (groupData.admins.contains(user.uid) ? null : user.uid)).tasks,
      child: Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text(groupData.name),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        actions: <Widget>[
            new FlatButton.icon(
            icon: Icon(Icons.add), 
            label: Text("Add Task"),
            onPressed: () => _showTaskAddPanel(), 
            )
        ],
          ),
      body: 
        TasksDataList(),
      )
    );
  }
}