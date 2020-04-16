import 'package:flutter/material.dart';
import 'package:project1/models/group_data_model.dart';
import 'package:project1/models/user.dart';
import 'package:project1/services/database.dart';
import 'package:project1/shared/constants.dart';
import 'package:provider/provider.dart';

class TaskAddForm extends StatefulWidget {
  final GroupDataModel groupData;
  @override
  TaskAddForm(this.groupData);
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
  DateTime _currentDeadline;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return SingleChildScrollView(
      child: Container(
        child: Form(
          key: _formkey,
          child: Column(
            children: <Widget>[
              Text(
                "Create Task",
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
              // (Ben) replace that TextFormField below with a dropdown list of strings
              // Theres also dropdown menu code that is commented out further below. Its from the tutorials, perhaps you can look at it for reference
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: "Employees"),
                validator: (val) => val.isEmpty ? "Please enter employees" : null,
                // change [val] to proper list later, need to make this some sort of dropdown but also be able to select multiple users
                onChanged: (val) => setState(() => _currentUsers = val.split(" ")),
              ),

              // (Ava) (Parul) add a date picker below (ignore all the commented code, its old stuff from the tutorials)
              Text(_currentDeadline == null ? 'No date has been picked yet' : _currentDeadline.toString()),
              RaisedButton(
                child: Text('Pick a date'),
                onPressed: () {
                  showDatePicker(
                    context: context,
                    initialDate: _currentDeadline == null ? DateTime.now() :
                    _currentDeadline,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030)
                  ).then((date) {
                      setState(() {
                      _currentDeadline = date;
                    });
                  });
                  },
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
                  "Submit",
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
