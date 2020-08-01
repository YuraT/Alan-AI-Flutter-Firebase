import 'package:flutter/material.dart';
import 'package:project1/models/group_data_model.dart';
import 'package:project1/models/task_data_model.dart';
import 'package:project1/models/user.dart';
import 'package:project1/screens/home/task/task_add_form.dart';
import 'package:project1/screens/wrapper.dart';
import 'package:project1/services/database.dart';
import 'package:provider/provider.dart';
import 'package:project1/screens/home/task/tasks_data_list.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:project1/shared/constants.dart';

class GroupDataScreen extends StatefulWidget {
  final GroupDataModel groupData;
  final GlobalKey<TasksDataListState> tasksDataKey;
  //GroupDataScreen({this.groupData});
  GroupDataScreen(
      {Key groupDataScreenKey, @required this.groupData, this.tasksDataKey})
      : super(key: groupDataScreenKey);

  @override
  GroupDataScreenState createState() => GroupDataScreenState();
}

class GroupDataScreenState extends State<GroupDataScreen> {
  GroupDataModel currentGroupData;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    setState(() {
      currentGroupData = widget.groupData;
      Wrapper.setVisuals(context);
    });
    void _showTaskAddPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: TaskAddForm(currentGroupData /*widget.groupData*/),
            );
          });
    }

    return Scaffold(
      backgroundColor: c,
      appBar: AppBar(
        title: Text(/*widget.groupData*/ currentGroupData.name),
        backgroundColor: a,
        elevation: 0.0,
        actions: <Widget>[
          // check if current user is admin and display manage group button
          if (this.currentGroupData.admins.contains(user.ref))
            IconButton(
              icon: Icon(Icons.settings),
              //label: Text("Manage Group"),
              onPressed: () {
                Navigator.pushNamed(context, "/manageGroup",
                    arguments: {"groupData": this.currentGroupData});
              },
            ),
          IconButton(
            icon: Icon(Icons.add),
            //label: Text('Add Task',
            //  style: TextStyle(fontSize: 15),),
            onPressed: () => _showTaskAddPanel(),
          ),
          IconButton(
            icon: Icon(Icons.share),
            //label: Text('Invite',
            //  style: TextStyle(fontSize: 15),),
            onPressed: () async {
              String vCode = await DatabaseService().getGroupInvite(
                  user.ref, /*widget.groupData*/ currentGroupData.ref);

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
      body: TasksDataList(tasksDataKey: Provider.of<Map<String, Key>>(context)["tasksDataKey"], group: currentGroupData,),
    );
  }
}
