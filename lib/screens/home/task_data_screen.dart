import 'package:flutter/material.dart';
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
    //final user = Provider.of<User>(context);
    setState(() {
      currentTaskData = widget.taskData; 
    });

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
            onPressed: () => {},
          ),
        ],
      ),

      body: Column(
        children: <Widget>[
          Text(currentTaskData.description),
        ],
      )
    );
  }
}
