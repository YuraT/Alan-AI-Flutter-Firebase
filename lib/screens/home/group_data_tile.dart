import 'package:flutter/material.dart';
import 'package:project1/models/group_data_model.dart';

class GroupDataTile extends StatelessWidget {
  final GroupDataModel groupData;
  GroupDataTile({this.groupData});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          title: Text("Group: ${groupData.name}"),
          subtitle: Text("users: ${groupData.users.toString()}, admins: ${groupData.admins.toString()}"),
        ),
      ),
    );
  }
}