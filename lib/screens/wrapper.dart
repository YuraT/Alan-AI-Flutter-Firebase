import "package:flutter/material.dart";
import 'package:project1/models/group_data_model.dart';
import 'package:project1/models/user.dart';
import 'package:project1/screens/authenticate/authenticate.dart';
import 'package:project1/screens/home/home.dart';
import 'package:project1/services/database.dart';
import 'package:provider/provider.dart';
import 'package:alan_voice/alan_voice.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}
class _WrapperState extends State<Wrapper> {
  bool _enabled = false;
  
  Future<String> _handleReadGroups(User _user) async {
      String result = "";
      print("here");
      List<GroupDataModel> _groups = await DatabaseService(userUid: _user.uid).groupsSnapshot;
      _groups.map((group) => {
        print("some BS + ${group.name}"),
        result += "${group.name}, "
      });
      return result;
    }
  
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    
    Future<void> _handleCommand(Map<String, dynamic> command) async {
      print("command: $command");
      // this shit doesnt work yet (I dont know how to do command handlers for now)
      // I think I might just restrucure the whole data structure to make it better for Alan (or maybe I wont)
      switch(command["command"]) {
        case "readGroups":
          //DatabaseService(userUid: uid)
          AlanVoice.playText("text");
          String _groups = await _handleReadGroups(user); // this returns null and I dont know why
          print("GROUPSTUFF: $_groups");
          //AlanVoice.playText(_groups);
          AlanVoice.playText("text 2");
          break;
      }
    }
    void _initAlanButton() async {
      //init Alan with sample project id
      AlanVoice.addButton("531dafb36d13902b724944e2c821de622e956eca572e1d8b807a3e2338fdd0dc/stage");
      //AlanVoice.setVisualState("visuals");
      setState(() {
        _enabled = true;
      });

      AlanVoice.callbacks.add((command) => _handleCommand(command.data));
    }
    
    // return authenticate or home depending on user status
    if (user == null) {
      _enabled = false;
      return Authenticate();
    } else {
      if (!_enabled) _initAlanButton();
      return Home();
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