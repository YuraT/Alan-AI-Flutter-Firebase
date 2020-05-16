import 'package:flutter/material.dart';
import 'package:project1/models/user_data_model.dart';
import 'package:project1/screens/home/user_data_tile.dart';
import 'package:provider/provider.dart';

class UsersDataList extends StatefulWidget {
  @override
  _UsersDataListState createState() => _UsersDataListState();
}

class _UsersDataListState extends State<UsersDataList> {
  @override
  Widget build(BuildContext context) {
    final usersData = Provider.of<List<UserDataModel>>(context) ?? [];
    usersData.forEach((userData) {
      print(userData.username);
      print(userData.firstName);
      print(userData.lastName);
    });

    return ListView.builder(
      itemCount: usersData.length,
      itemBuilder: (context, index) {
        return UserDataTile(userData: usersData[index]);
      },
    );
  }
}