import 'package:flutter/material.dart';
import 'package:project1/models/group_data_model.dart';
import 'package:project1/models/user.dart';
import 'package:project1/screens/home/task_add_form.dart';
import 'package:project1/services/database.dart';
import 'package:provider/provider.dart';
import 'package:project1/screens/home/tasks_data_list.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class GroupDataScreen extends StatefulWidget {
  final GroupDataModel groupData;
  final GlobalKey<TasksDataListState> tasksDataKey;
  //GroupDataScreen({this.groupData});
  GroupDataScreen({Key groupDataScreenKey, @required this.groupData, this.tasksDataKey}) : super(key: groupDataScreenKey);

  @override
  GroupDataScreenState createState() => GroupDataScreenState();
}

class GroupDataScreenState extends State<GroupDataScreen> {
  GroupDataModel currentGroupData;
  
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    setState(() {
      currentGroupData = widget.groupData;//
    });
    void _showTaskAddPanel() {
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: TaskAddForm(currentGroupData/*widget.groupData*/),
        );
      });
    }
    return StreamProvider<List<TaskDataModel>>.value(
      // userUid is only specified if the user is not included in the admins list of the group, who should be able to see all tasks
      value: DatabaseService(groupUid: currentGroupData.uid/*widget.groupData.uid*/, userUid: (/*widget.groupData*/currentGroupData.admins.contains(user.uid) ? null : user.uid)).tasks,
      child: Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text(/*widget.groupData*/currentGroupData.name),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.add), 
            label: Text("Add Task"),
            onPressed: () => _showTaskAddPanel(), 
            ),
          FlatButton.icon(
            icon: Icon(Icons.share),
            label: Text('Join Code'),
            onPressed: () async {
              String vCode = await DatabaseService().getGroupInvite(user.uid, /*widget.groupData*/currentGroupData.uid);

              Alert(
                context: context,
                type: AlertType.success,
                title: "$vCode",
                desc: "Here is your verification code",
                buttons: [
                  DialogButton(
                    child: Text(
                      "Close",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () => Navigator.pop(context),
                    width: 120,
                  )
                ],
              ).show();
            },
          )
        ],
          ),
      body: 
        TasksDataList(tasksDataKey: widget.tasksDataKey /*Provider.of<Map<String, Key>>(context)["tasksDataKey"]*/),
      )
    );
  }
}