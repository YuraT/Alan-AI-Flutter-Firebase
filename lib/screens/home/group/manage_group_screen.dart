import 'package:flutter/material.dart';
import 'package:project1/models/group_data_model.dart';
import 'package:project1/models/user_data_model.dart';
import 'package:project1/services/database.dart';
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
      currentUsersData = Provider.of<List<UserDataModel>>(context).where((user) => currentGroupData.users.contains(user.ref) && !currentGroupData.admins.contains(user.ref)).toList();
    });
    return Scaffold(
      backgroundColor: c,
      appBar: AppBar(
        title: Text("Manage ${currentGroupData.name}"),
        backgroundColor: a,
        elevation: 0.0,
      ),
      body: ListView.builder(
        itemCount: currentUsersData.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Card(
              margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
              child: ListTile(
                  title: Text(currentUsersData[index].username),
                  subtitle: Text("First Name: ${currentUsersData[index].firstName}, Last Name: ${currentUsersData[index].lastName}"),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle), 
                    onPressed: () {
                      DatabaseService().updateGroupData(
                      currentGroupData.ref, 
                      {"users": currentGroupData.users.remove(currentUsersData[index].ref)}
                    ).then((value) => setState(() {
                      currentGroupData = currentGroupData;
                    }));
                    },
                  ),
              ),
            ),
          );
        }
      ),
    );
  }
}