import "package:flutter/material.dart";
import 'package:project1/models/group_data_model.dart';
import 'package:project1/models/user.dart';
import 'package:project1/models/user_data_model.dart';
import 'package:project1/route_generator.dart';
import 'package:project1/screens/authenticate/authenticate.dart';
import 'package:project1/screens/home/group_data_screen.dart';
import 'package:project1/screens/home/lists/groups_list.dart';
import 'package:project1/screens/home/home.dart';
import 'package:project1/screens/home/task_add_form.dart';
import 'package:project1/screens/home/lists/tasks_data_list.dart';
import 'package:project1/services/database.dart';
import 'package:provider/provider.dart';
import 'package:alan_voice/alan_voice.dart';

// for new data just add keys here
// might not need this with the new structure
final Map<String, Key> keys = {
  "groupsDataKey" : groupsDataKey,
  "groupDataScreenKey" : groupDataScreenKey,
  "tasksDataKey": tasksDataKey

};

final groupsDataKey = GlobalKey<GroupsListState>();
final groupDataScreenKey = GlobalKey<GroupDataScreenState>();
final tasksDataKey = GlobalKey<TasksDataListState>();

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}
class _WrapperState extends State<Wrapper> {
  bool _enabled = false;
  
  String _handleReadGroups() {
    String result = "";
    groupsDataKey.currentState.groupsOfCurrentUser.forEach((group) => {
      result += group.name + ", ",
    });
    return result;
    }

  String _handleReadTasks(String groupName) {
    if (groupName != null) {
      _handleEnterGroup(groupName);
    }
    if (tasksDataKey.currentState == null) { 
      return null;
      }
    else {
      String result = "";
      tasksDataKey.currentState.currentTasksData.forEach((task) => {
        result += task.title + ", ",
      });
      return result;
    }
  }
  
  void _handleEnterGroup(String groupName) {
    var groupData = groupsDataKey.currentState.groupsOfCurrentUser.singleWhere((group) => group.name.toLowerCase() == groupName.toLowerCase(), orElse: () => null);
    if (groupData != null) {
      // for now it generates widges one on top of the other regardless of cotext
      // this causes the widgets to pile up and its not good, but I didnt have time to fix it
      // will fix later

      // some context testing
      // print("context.widget.toStringShort:");
      // print("context.widget.toStringShort: ${context.widget.toStringShort()}");
      if (groupDataScreenKey.currentState == null){
        Navigator.of(context).pushNamed(
          '/groupData',
          arguments: {
            "groupDataScreenKey": groupDataScreenKey, 
            "groupData": groupData, 
            "tasksDataKey": tasksDataKey
          }
        );
      } else {
        if (groupDataScreenKey.currentState.currentGroupData != groupData) {
          Navigator.of(context).pushReplacementNamed(
            '/groupData',
            arguments: {
              "groupDataScreenKey": groupDataScreenKey, 
              "groupData": groupData, 
              "tasksDataKey": tasksDataKey
            }
          );
        }
      }
    } else return null;
  }

  _handleAppendTask(String task, String groupName) {
    if (groupName != null) _handleEnterGroup(groupName);
    showModalBottomSheet(context: context, builder: (context) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
        child: TaskAddForm(groupDataScreenKey.currentState.currentGroupData, task)
      );
    });

    AlanVoice.playText("creating task"+ task);
    AlanVoice.playText("group is: "+ groupName);
  }
  
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    /*Future<void>*/ void _handleCommand(Map<String, dynamic> command) /*async*/ {
      print("command: $command");
      switch(command["command"]) {
        case "readGroups":
          String _groups = _handleReadGroups();
          AlanVoice.playText("$_groups");
          break;
        case "enterGroup":
          _handleEnterGroup(command["groupName"]);
          break;
        case "readTasks":
          String _tasks = _handleReadTasks(command["groupName"]?? null);
          if (_tasks == null) AlanVoice.playText("could not read tasks");
          else AlanVoice.playText("$_tasks");
          break;
        case "createTask":
          // Create task handler
          _handleAppendTask(command["task"], command["groupName"]);
          AlanVoice.playText("task added successfully.");
          break;
        case "signOut":
          // signing out handler
          break;
      }
    }
    void _initAlanButton() async {
      // init Alan with sample project id
      AlanVoice.addButton("db7b891a6e5f7daa61c56ee3d619bfeb2e956eca572e1d8b807a3e2338fdd0dc/stage");
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
      return Home();
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


class DataStream extends StatelessWidget {
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
        Provider<Map<String, Key>>.value(
          value: keys
        ),
      ],
      child: MaterialApp(
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}