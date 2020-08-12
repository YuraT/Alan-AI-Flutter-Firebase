import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project1/models/group_data_model.dart';
import 'package:project1/models/user.dart';
import 'package:project1/models/user_data_model.dart';
import 'package:project1/services/database.dart';
import 'package:project1/shared/constants.dart';
import 'package:project1/shared/multi_select.dart';
import 'package:provider/provider.dart';

class TaskAddForm extends StatefulWidget {
  final GroupDataModel groupData;
  final String initialTitle;
  final String initialDescription;
  final List<DocumentReference> initialUsers;
  final DateTime initialDeadline;
  @override
  TaskAddForm(
    this.groupData, 
    {
      this.initialTitle, 
      this.initialDescription, 
      this.initialUsers, 
      this.initialDeadline
    }
  );
  _TaskAddFormState createState() => _TaskAddFormState(
    title: TextEditingController(text: initialTitle), 
    description: TextEditingController(text: initialDescription), 
    users: initialUsers, 
    deadline: initialDeadline
  );
}

class _TaskAddFormState extends State<TaskAddForm> {
  final _formkey = GlobalKey<FormState>();
  //final List<String> sugars = ['0','1','2','3','4'];

  // form values
  TextEditingController title;
  TextEditingController description;  
  List<DocumentReference> users;
  DateTime deadline;
  _TaskAddFormState({this.title, this.description, this.users, this.deadline});
  //MULTI SELECT FUNCTION

  List<MultiSelectDialogItem<DocumentReference>> multiItem = List();

  void populateMultiSelect(Map<DocumentReference, String> valuesToPopulate) {
    for (DocumentReference v in valuesToPopulate.keys) {
      multiItem.add(MultiSelectDialogItem(v, valuesToPopulate[v]));
    }
  }

  void _showMultiSelect(BuildContext context) async {
    multiItem = [];
    Map<DocumentReference, String> valuesToPopulate = {};
    Provider.of<List<UserDataModel>>(context)
        .where((user) => widget.groupData.users.contains(user.ref))
        .forEach((user) {
      // have to add a method later to only let admins assign to all users
      valuesToPopulate.putIfAbsent(
          user.ref, () => user.firstName + " " + user.lastName);
    });
    populateMultiSelect(valuesToPopulate);
    final items = multiItem;

    final selectedValues = await showDialog<Set<DocumentReference>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: items,
          initialSelectedValues: (users != null
              ? users.toSet()
              : null), // initially select users from state
        );
      },
    );
    if (selectedValues != null && selectedValues.length != 0) {
      setState(() {
        users = selectedValues.toList();
      });
    }
    print("selectedValues: $selectedValues");
    //getvaluefromkey(selectedValues);
  }

  /*void getvaluefromkey(Set selection){
    if (selection != null){
      for(String x in selection.toList()){
        print(valuesToPopulate[x]);
      }
    }
  }*/


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
                controller: title,
                decoration: textInputDecoration.copyWith(hintText: "Title"),
                validator: (val) => val.isEmpty ? "Please enter title" : null,
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                controller: description,
                decoration:
                  textInputDecoration.copyWith(hintText: "Description"),
                validator: (val) =>
                    val.isEmpty ? "Please enter description" : null,
              ),
              SizedBox(
                height: 20.0,
              ),
              // (Ben) replace that TextFormField below with a dropdown list of strings
              // Theres also dropdown menu code that is commented out further below. Its from the tutorials, perhaps you can look at it for reference

              RaisedButton(
                child: Text("Select Employees"),
                onPressed: () => _showMultiSelect(context),
              ),
              SizedBox(
                height: 10.0,
              ),

              /*  TextFormField(
                decoration: textInputDecoration.copyWith(hintText: "Employees"),
                validator: (val) => val.isEmpty ? "Please enter employees" : null,
                // change [val] to proper list later, need to make this some sort of dropdown but also be able to select multiple users
                onChanged: (val) => setState(() => users = val.split(" ")),
              ),
*/
              // (Ava) (Parul) add a date picker below (ignore all the commented code, its old stuff from the tutorials)
              Text(deadline == null
                  ? 'No date has been picked yet'
                  : deadline.toString()),
              RaisedButton(
                child: Text('Pick a date'),
                onPressed: () {
                  showDatePicker(
                          context: context,
                          initialDate: deadline?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030))
                      .then((date) {
                    setState(() {
                      deadline = date;
                    });
                  });
                },
              ),
              SizedBox(
                height: 10.0,
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
                color: b,
                child: Text(
                  "test button",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  title.text = "tudun";
                }
              ),
              RaisedButton(
                color: b,
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (_formkey.currentState.validate()) {
                    await DatabaseService().createTask(
                      title.text,
                      description.text,
                      widget.groupData.ref,
                      user.ref,
                      users,
                      deadline,
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
