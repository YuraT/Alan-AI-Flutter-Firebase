import 'package:flutter/material.dart';
import 'package:project1/models/group_data_model.dart';
import 'package:project1/screens/home/group_data_tile.dart';
import 'package:project1/models/user_data_model.dart';
import 'package:project1/screens/home/user_data_tile.dart';
import 'package:provider/provider.dart';

class GroupsDataList extends StatefulWidget {
  @override
  _GroupsDataListState createState() => _GroupsDataListState();
}

class _GroupsDataListState extends State<GroupsDataList> {
  @override
  Widget build(BuildContext context) {
    final groupsData = Provider.of<List<GroupDataModel>>(context) ?? [];
    final usersData = Provider.of<List<UserDataModel>>(context)?? [];
    groupsData.forEach((groupData) {
      print(groupData.name);
      print(groupData.users);
      print(groupData.admins);
      return Text("something");
    });

    //List<dynamic> lists = [groupsData, usersData];
    return Column(
      children: <Widget>[
        Text("Groups: "),
        // groups list view builder
        ListView.builder(
          shrinkWrap: true,
          itemCount: groupsData.length,
          itemBuilder: (context, index) {
          return GroupDataTile(groupData: groupsData[index]);
          },
        ),

        Text("Users (all users, not specific to groups yet)"),
        Text("(Not to be present here in final version)"),
        // users list view builder (not to be present here in final version)
        ListView.builder(
          shrinkWrap: true,
          itemCount: usersData.length,
          itemBuilder: (context, index) {
            return UserDataTile(userData: usersData[index]);
            }
        )
      ],
    );
  }
}