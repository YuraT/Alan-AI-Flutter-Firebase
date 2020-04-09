import "package:flutter/material.dart";
import 'package:project1/models/user.dart';
import 'package:project1/models/user_data_model.dart';
import 'package:project1/screens/home/groups_data_list.dart';
import 'package:project1/models/group_data_model.dart';
import 'package:project1/screens/home/settings_form.dart';
//import 'package:project1/screens/home/users_data_list.dart'; doesnt need to be here atm
import 'package:project1/services/auth.dart';
import 'package:project1/services/database.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    void _showSettingsPanel() {
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: SettingsForm(),
        );
      });
    } 

    // this code is not used anymore for now
    /*return StreamProvider<List<UserDataModel>>.value(
      value: DatabaseService().users,
      child: Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text("App 1"),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () async {
              await _auth.signOut();
            }, 
            icon: Icon(Icons.exit_to_app), 
            label: Text("Logout")
            ),
          FlatButton.icon(
            icon: Icon(Icons.settings), 
            label: Text("Settings"),
            onPressed: () => _showSettingsPanel(), 
            )
          ],
          ),
      body: 
        UsersDataList()
      )
    );*/

    return MultiProvider(
      providers: [
        StreamProvider<List<UserDataModel>>.value(
          value: DatabaseService().users),
        StreamProvider<List<GroupDataModel>>.value(
          value: DatabaseService(uid: user.uid).groups),
      ],
      child: Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text("App 1"),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () async {
              await _auth.signOut();
            }, 
            icon: Icon(Icons.exit_to_app), 
            label: Text("Logout")
            ),
          FlatButton.icon(
            icon: Icon(Icons.settings), 
            label: Text("Settings"),
            onPressed: () => _showSettingsPanel(), 
            )
          ],
          ),
      body: 
        GroupsDataList(),
      )
    );
  }
}