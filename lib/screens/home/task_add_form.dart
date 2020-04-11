import 'package:flutter/material.dart';
import 'package:project1/models/group_data_model.dart';
import 'package:project1/models/user.dart';
import 'package:project1/services/database.dart';
import 'package:project1/shared/constants.dart';
import 'package:project1/shared/loading.dart';
import 'package:provider/provider.dart';

class TaskAddForm extends StatefulWidget {
  @override
  final GroupDataModel groupData;
  TaskAddForm({this.groupData});
  _TaskAddFormState createState() => _TaskAddFormState(groupData);
}

class _TaskAddFormState extends State<TaskAddForm> {
  final GroupDataModel groupData;
  _TaskAddFormState(this.groupData);
  final _formkey = GlobalKey<FormState>();
  //final List<String> sugars = ['0','1','2','3','4'];

  // form values
  String _currentTitle;
  String _currentDescription;
  List<String> _currentUsers;
  DateTime _currentDeadline = DateTime.utc(2020);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Form(
      key: _formkey,
      child: Column(
        children: <Widget>[
          Text(
            "Update your settings",
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(
            height: 20.0,
          ),
          TextFormField(
            decoration: textInputDecoration.copyWith(hintText: "Title"),
            validator: (val) => val.isEmpty ? "Please enter title" : null,
            onChanged: (val) => setState(() => _currentTitle = val),
          ),
          SizedBox(
            height: 20.0,
          ),
          TextFormField(
            decoration: textInputDecoration.copyWith(hintText: "Description"),
            validator: (val) => val.isEmpty ? "Please enter description" : null,
            onChanged: (val) => setState(() => _currentDescription = val),
          ),
          SizedBox(
            height: 20.0,
          ),
          TextFormField(
            decoration: textInputDecoration.copyWith(hintText: "Employees"),
            validator: (val) => val.isEmpty ? "Please enter employees" : null,
            // change [val] to proper list later, need to make this some sort of dropdown but also be able to select multiple users
            onChanged: (val) => setState(() => _currentUsers = val.split(" ")),
          ),
          // dropdown menu
          // not in use anymore
          /*DropdownButtonFormField(
                  decoration: textInputDecoration,
                  value: _currentSugars ?? currentUser.sugars,
                  items: sugars.map((sugar) {
                    return DropdownMenuItem(
                      value: sugar,
                      child: Text("$sugar sugars"),
                    );
                  }).toList(), 
                  onChanged: (val) => setState(() => _currentSugars = val),
                  ),*/
          // slider
          // also not in use anymore
          /*Slider(
                  value: (_currentStrength ?? currentUser.strength).toDouble(),
                  activeColor: Colors.brown[_currentStrength ?? currentUser.strength],
                  inactiveColor: Colors.brown[_currentStrength ?? currentUser.strength],
                  min: 100,
                  max: 900,
                  divisions: 8,
                  onChanged: (val) => setState(() => _currentStrength = val.round()),
                ),*/
          RaisedButton(
            color: Colors.pink[400],
            child: Text(
              "Update",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              if (_formkey.currentState.validate()) {
                await DatabaseService(userUid: user.uid).createTask(
                  _currentTitle,
                  _currentDescription,
                  groupData.uid,
                  user.uid,
                  _currentUsers,
                  _currentDeadline,
                  false,
                );
                Navigator.pop(context);
              }
            },
          )
        ],
      ),
    );
  }
}
