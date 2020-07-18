import "package:flutter/material.dart";
import 'package:project1/screens/home/group/groups_list.dart';
import 'package:project1/screens/home/group/add_group_form.dart';
import 'package:project1/screens/home/settings_form.dart';
import 'package:project1/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:project1/shared/constants.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: SettingsForm(),
            );
          });
    }

    void _showAddGroupPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: AddGroupForm(),
            );
          });
    }

    return Scaffold(
      backgroundColor: c,
      appBar: AppBar(
        title: Text("TaskV"),
        backgroundColor: a,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: Icon(Icons.exit_to_app),
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => _showSettingsPanel(),
          ),
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () => _showAddGroupPanel(),
          )
        ],
      ),
      body: GroupsList(
        groupsDataKey: Provider.of<Map<String, Key>>(context)["groupsDataKey"],
      ),
    );
  }
}
