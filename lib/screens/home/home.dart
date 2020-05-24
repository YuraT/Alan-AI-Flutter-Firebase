import "package:flutter/material.dart";
import 'package:project1/screens/home/lists/groups_list.dart';
import 'package:project1/screens/home/add_group_form.dart';
import 'package:project1/screens/home/settings_form.dart';
import 'package:project1/services/auth.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();
  
  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: SettingsForm(),
        );
      });
    }
    void _showAddGroupPanel() {
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: AddGroupForm(),
        );
      });
    }

    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 10.0,
        title: Image.asset('assets/images/logo_only.png'),
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
            ),
          FlatButton.icon(
            icon: Icon(Icons.add_circle_outline),
            label: Text("New Group"),
            onPressed: () => _showAddGroupPanel(),
            )
          ],
          ),
      body: 
        GroupsList(groupsDataKey: Provider.of<Map<String, Key>>(context)["groupsDataKey"],),
      );
  }
}
