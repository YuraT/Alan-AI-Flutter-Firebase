import 'package:flutter/material.dart';
import 'package:project1/models/user.dart';
import 'package:project1/screens/wrapper.dart';
import 'package:project1/services/auth.dart';
import "package:provider/provider.dart";


void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: DataStream(),
    );
    /*return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );*/
  }
}

/*class DataStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<UserDataModel>>.value(
          value: Provider.of<User>(context) == null ? null :
            DatabaseService(/*add condition here later*/).users
        ),
        StreamProvider<List<GroupDataModel>>.value(
          value: Provider.of<User>(context) == null ? null :
            DatabaseService(userUid: Provider.of<User>(context).uid).groups
        ),
        StreamProvider<List<TaskDataModel>>.value(
          value: Provider.of<User>(context) == null ? null :
            DatabaseService(userUid: Provider.of<User>(context).uid).tasks
        ),
      ],
      child: MaterialApp(
        home: Provider<Map<String, Key>>.value(value: keys, child:Wrapper()),
      )
    );
  }
}*/