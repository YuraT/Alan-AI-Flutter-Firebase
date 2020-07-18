import 'package:flutter/material.dart';
import 'package:project1/models/group_data_model.dart';
import 'package:project1/models/user_data_model.dart';
import 'package:project1/screens/home/user_data_tile.dart';
import 'package:project1/shared/constants.dart';
import 'package:provider/provider.dart';

class ManageGroupScreen extends StatefulWidget {
  final GroupDataModel groupData;
  ManageGroupScreen({
    // will have to provide a key later for this
    Key manageGroupScreenKey,
    @required this.groupData,
  }) : super(key: manageGroupScreenKey);

  @override
  ManageGroupScreenState createState() => ManageGroupScreenState();
}

class ManageGroupScreenState extends State<ManageGroupScreen> {
  GroupDataModel currentGroupData;
  List<UserDataModel> currentUsersData;

  @override
  Widget build(BuildContext context) {
    setState(() {
      currentGroupData = widget.groupData;
      currentUsersData = Provider.of<List<UserDataModel>>(context).where((user) => currentGroupData.users.contains(user.uid) && !currentGroupData.admins.contains(user.uid)).toList();
    });
    return Scaffold(
      backgroundColor: c,
      appBar: AppBar(
        title: Text("M-${currentGroupData.name}"),
        backgroundColor: a,
        elevation: 0.0,
      ),
      body: ListView.builder(
        itemCount: currentUsersData.length,
        itemBuilder: (context, index) {
          return UserDataTile(userData: currentUsersData[index]);
        }
      ),
    );
  }
}