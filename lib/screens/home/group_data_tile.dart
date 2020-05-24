import 'package:flutter/material.dart';
import 'package:project1/models/group_data_model.dart';
import 'package:project1/models/user.dart';
import 'package:provider/provider.dart';

class GroupDataTile extends StatelessWidget {
  final GroupDataModel groupData;
  GroupDataTile({this.groupData});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text("Group: ${groupData.name}"),
              // subtitle is the amount of tasks in the group assigned to the logged in user
              subtitle: Text("Your Tasks: ${Provider.of<List<TaskDataModel>>(context).where((task) => task.group == groupData.uid /*&& task.users.contains(Provider.of<User>(context))*/).length}"),
            ),
            RaisedButton(
              child: Text("route"), 
              onPressed: () {
                Key groupDataScreenKey = Provider.of<Map<String,Key>>(context)["groupDataScreenKey"];
                Key tasksDataKey = Provider.of<Map<String,Key>>(context)["tasksDataKey"];

                Navigator.of(context).pushNamed(
                  '/groupData',
                  arguments: {
                    "groupDataScreenKey": groupDataScreenKey, 
                    "groupData": groupData, 
                    "tasksDataKey": tasksDataKey
                  }
                );
              },
            )
          ],
        ),
      ),
    );
  }
}