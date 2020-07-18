import 'package:flutter/material.dart';
import 'package:project1/models/group_data_model.dart';
import 'package:project1/models/user.dart';
import 'package:provider/provider.dart';
import 'package:project1/shared/constants.dart';

class GroupDataTile extends StatelessWidget {
  final GroupDataModel groupData;
  GroupDataTile({this.groupData});

  @override
  Widget build(BuildContext context) {
    List<TaskDataModel> tasks = Provider.of<List<TaskDataModel>>(context);
    return Padding(
      padding: EdgeInsets.only(top: 8.0,),
      child: Card(
        shape: RoundedRectangleBorder(
            side: BorderSide(color:Colors.grey, width: 2.0),
            borderRadius: BorderRadius.circular(4.0)),
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text("Group: ${groupData.name}"), // subtitle is the amount of tasks in the group assigned to the logged in user
              subtitle: Text("Your Tasks: ${tasks.where((task) => task.group == groupData.uid && task.users.contains(Provider.of<User>(context).uid) && !task.completedStatus).length}"),
              trailing: Icon(
                Icons.arrow_forward,
                color: b,
              ),
              onTap: () {
                Key groupDataScreenKey = Provider.of<Map<String, Key>>(
                    context)["groupDataScreenKey"];
                Key tasksDataKey =
                Provider.of<Map<String, Key>>(context)["tasksDataKey"];

                Navigator.of(context).pushNamed('/groupData', arguments: {
                  "groupDataScreenKey": groupDataScreenKey,
                  "groupData": groupData,
                  "tasksDataKey": tasksDataKey
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
