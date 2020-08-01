import 'package:flutter/material.dart';
import 'package:project1/models/group_data_model.dart';
import 'package:project1/screens/home/group/group_data_tile.dart';
import 'package:project1/screens/wrapper.dart';
import 'package:project1/shared/loading.dart';
import 'package:provider/provider.dart';

class GroupsList extends StatefulWidget {
  GroupsList({Key groupsDataKey}) : super(key: groupsDataKey);
  @override
  GroupsListState createState() => GroupsListState();
}
class GroupsListState extends State<GroupsList> {
  List<GroupDataModel> groupsOfCurrentUser;

  @override
  Widget build(BuildContext context) {
    final groupsData = Provider.of<List<GroupDataModel>>(context) ?? [];
    setState(() {
      groupsOfCurrentUser = groupsData;
      Wrapper.setVisuals(context);
    });
    /*groupsData.forEach((groupData) {
      print(groupData.name);
      print(groupData.users);
      print(groupData.admins);
      return Text("something");
    });*/

    //List<dynamic> lists = [groupsData, usersData];
    return groupsOfCurrentUser == null? Loading():
    SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Text("This User's Groups: "),
          // groups list view builder
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: groupsOfCurrentUser.length,
            itemBuilder: (context, index) {
              return GroupDataTile(groupData: groupsOfCurrentUser[index]);
            },
          ),
        ],
      ),
    );
  }
}
