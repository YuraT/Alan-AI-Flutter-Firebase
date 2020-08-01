import 'dart:convert';

import "package:flutter/material.dart";
import 'package:project1/models/group_data_model.dart';
import 'package:project1/models/task_data_model.dart';
import 'package:project1/models/user.dart';
import 'package:project1/models/user_data_model.dart';
import 'package:project1/route_generator.dart';
import 'package:project1/screens/authenticate/authenticate.dart';
import 'package:project1/screens/home/group/group_data_screen.dart';
import 'package:project1/screens/home/group/groups_list.dart';
import 'package:project1/screens/home/home.dart';
import 'package:project1/screens/home/task/task_add_form.dart';
import 'package:project1/screens/home/task/task_data_screen.dart';
import 'package:project1/screens/home/task/tasks_data_list.dart';
import 'package:project1/services/database.dart';
import 'package:provider/provider.dart';
import 'package:alan_voice/alan_voice.dart';
// for new data just add keys here
// might not need this with the new structure
final Map<String, Key> keys = {
  "groupsDataKey" : groupsDataKey,
  "tasksDataKey": tasksDataKey,
  "groupDataScreenKey" : groupDataScreenKey,
  "taskDataScreenKey" : taskDataScreenKey,

};
final groupsDataKey = GlobalKey<GroupsListState>();
final tasksDataKey = GlobalKey<TasksDataListState>();
final groupDataScreenKey = GlobalKey<GroupDataScreenState>();
final taskDataScreenKey = GlobalKey<TaskDataScreenState>();

class Wrapper extends StatefulWidget {
  static setVisuals(BuildContext context) {
    var visuals = {
      "screen": ModalRoute.of(context).settings.name,
      "currentUser": Provider.of<User>(context).ref.documentID,
      "currentData": {
        "groupsData": groupsDataKey.currentState == null? null : groupsDataKey.currentState.groupsOfCurrentUser,
        "tasksData": tasksDataKey.currentState == null? null : tasksDataKey.currentState.currentTasksData,
        "groupDataScreen" : groupDataScreenKey.currentState == null? null : groupDataScreenKey.currentState.currentGroupData,
        "taskDataScreen" : taskDataScreenKey.currentState == null? null : taskDataScreenKey.currentState.currentTaskData,
      },
      "global": {
        "groups": Provider.of<List<GroupDataModel>>(context)?? [],
        "users": Provider.of<List<UserDataModel>>(context)?? [],
        "tasks": Provider.of<List<TaskDataModel>>(context)?? []
      }
    };
    print("visuals ${json.encode(visuals)}");
    AlanVoice.setVisualState(json.encode(visuals));
  }
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

  void _handleCreateTask({String groupName, String title, String description}) {
    if (groupName != null) _handleEnterGroup(groupName);
    showModalBottomSheet(context: context, builder: (context) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
        child: TaskAddForm(groupDataScreenKey.currentState.currentGroupData, initialTitle: title, initialDescription: description,)
      );
    });

    AlanVoice.playText("creating task"+ title);
    AlanVoice.playText("group is: "+ groupName);
  }

  void _handleCompleteCurrentTask() {
    if (taskDataScreenKey.currentState == null) {
      AlanVoice.playText("you are not on a task screen"); 
    }
    DatabaseService().updateTaskData(
      taskDataScreenKey.currentState.currentTaskData.ref, 
      {"completedStatus": true}
    );
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
          AlanVoice.setVisualState("{\"screen\":\"screendata\"}");
          break;
        case "readTasks":
          String _tasks = _handleReadTasks(/*command["groupName"]??*/ null);
          if (_tasks == null) AlanVoice.playText("could not read tasks");
          else AlanVoice.playText("$_tasks");
          break;
        case "createTask":
          // Create task handler
          _handleCreateTask(groupName: command["groupName"], title: command["task"], description: command["description"]);
          AlanVoice.playText("task added successfully.");
          break;
        case "completeTask":
          _handleCompleteCurrentTask();
          break;
        case "currentVisualState":
          print("currentVisualState: ${command["visual"]}");
          break;
        case "signOut":
          // signing out handler
          break;
      }
    }
    void _initAlanButton() async {
      // init Alan with sample project id
      AlanVoice.addButton("13362eada708f6f258aea1955415dde32e956eca572e1d8b807a3e2338fdd0dc/stage");
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
    }
  }
}


class DataStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<GroupDataModel>>.value(
      value: Provider.of<User>(context) == null ? null :
        DatabaseService(userRef: Provider.of<User>(context).ref).groups,
      child: _UsersAndTasks()
    );
  }
}

class _UsersAndTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<GroupDataModel> groups = Provider.of<List<GroupDataModel>>(context);
    return MultiProvider(
      providers: [
        StreamProvider.value(
          value: groups == null? null : DatabaseService()
          .users(groups.expand((group) => group.users.map((user) => user.documentID)).toList())
        ),
        StreamProvider.value(
          value: groups == null? null : DatabaseService(
            groupRefs: groups.map((group) => group.ref).toList()
          ).tasks
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