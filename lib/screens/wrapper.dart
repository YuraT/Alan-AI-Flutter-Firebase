import "package:flutter/material.dart";
import 'package:project1/models/user.dart';
import 'package:project1/screens/authenticate/authenticate.dart';
import 'package:project1/screens/home/groups_list.dart';
import 'package:project1/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'package:alan_voice/alan_voice.dart';

// for new data just add keys here
final keys = {
  "groupsDataKey" : groupsDataKey,
};

final groupsDataKey = GlobalKey<GroupsListState>();
class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}
class _WrapperState extends State<Wrapper> {
  bool _enabled = false;
  
  /*Future<String>*/ String _handleReadGroups(User _user) /*async*/ {
      String result = "";
      /*List<GroupDataModel> _groups = await DatabaseService(userUid: _user.uid).groupsSnapshot;
      _groups.map((group) => {
        result += "${group.name}, "
      }).toList();*/
      groupsDataKey.currentState.groupsOfCurrentUser.forEach((group) => {
        result += group.name + ", ",
      });
      return result;
    }
  
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    
    /*Future<void>*/ void _handleCommand(Map<String, dynamic> command) /*async*/ {
      print("command: $command");
      // I think I might just restrucure the whole data structure to make it better for Alan (or maybe I wont)
      switch(command["command"]) {
        case "readGroups":
          /*Future<String>*/ String _groups = _handleReadGroups(user);
          /*_groups.then((data) => {
            AlanVoice.playText("groupdata $data")
            }
          );*/
          AlanVoice.playText("$_groups");
          break;
      }
    }
    void _initAlanButton() async {
      // init Alan with sample project id
      AlanVoice.addButton("531dafb36d13902b724944e2c821de622e956eca572e1d8b807a3e2338fdd0dc/stage");
      //AlanVoice.setVisualState({"screen": "groupScreen"}.toString());
      setState(() {
        _enabled = true;
      });

      AlanVoice.callbacks.add((command) => _handleCommand(command.data));
    }
    
    // return authenticate or home depending on user status
    // also remove or initialize alan button
    if (user == null) {
      setState(() {
        _enabled = false; 
        AlanVoice.clearCallbacks();
      });
      return Authenticate();
    } else {
      if (!_enabled) setState(() {_initAlanButton();});
      return Provider<Map<String, Key>>.value(value: keys, child: Home(),);
      //return Home(groupsDataKey: groupsDataKey,);
    }
  }
}

/*class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    
    // return authenticate or home depending on user status
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}*/