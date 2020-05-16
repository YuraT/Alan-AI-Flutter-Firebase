import 'package:flutter/material.dart';
import 'package:project1/models/group_data_model.dart';
import 'package:project1/models/user.dart';
import 'package:project1/screens/home/task_add_form.dart';
import 'package:project1/services/database.dart';
import 'package:provider/provider.dart';
import 'package:project1/screens/home/tasks_data_list.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
          child: TaskAddForm(groupData),
        );
      });
    }
    return StreamProvider<List<TaskDataModel>>.value(
      // userUid is only specified if the user is not included in the admins list of the group, who should be able to see all tasks
      value: DatabaseService(groupUid: groupData.uid, userUid: (groupData.admins.contains(user.uid) ? null : user.uid)).tasks,
      child: Scaffold(
            resizeToAvoidBottomPadding: false,
      backgroundColor: Color.fromARGB(255, 229, 235, 239),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 10.0,
        title: Image.asset('assets/images/logo_only.png', height: 50.0),

        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.add), 
            label: Text("Add Task"),
            onPressed: () => _showTaskAddPanel(), 
            ),
            // (Avnish) add button that allows getting one-use invite code to group
          FlatButton.icon(
            icon: Icon(Icons.share),
            label: Text('Join Code'),
            onPressed: () async {
              String vCode = await DatabaseService().getGroupInvite(user.uid, groupData.uid);

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
        TasksDataList(),
      )
    );
  }
}