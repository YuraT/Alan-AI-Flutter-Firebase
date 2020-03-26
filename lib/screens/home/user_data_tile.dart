import 'package:flutter/material.dart';
import 'package:project1/models/user_data_model.dart';

class UserDataTile extends StatelessWidget {
  final UserDataModel userData;
  UserDataTile({this.userData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.brown[userData.strength],
            ),
            title: Text(userData.name),
            subtitle: Text("Takes ${userData.sugars} sugar"),
        ),
      ),
    );
  }
}