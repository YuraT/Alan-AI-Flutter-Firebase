import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project1/models/group_data_model.dart';
import 'package:project1/models/user.dart';
import 'package:project1/models/user_data_model.dart';
import 'package:project1/services/database.dart';
import 'package:project1/shared/constants.dart';
import 'package:provider/provider.dart';

// START StackOverflow Code

class MultiSelectDialogItem<T> {
  const MultiSelectDialogItem(this.value, this.label);

  final T value;
  final String label;
}

class MultiSelectDialog<T> extends StatefulWidget {
  MultiSelectDialog({Key key, this.items, this.initialSelectedValues})
      : super(key: key);

  final List<MultiSelectDialogItem<T>> items;
  final Set<T> initialSelectedValues;

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState<T>();
}

class _MultiSelectDialogState<T> extends State<MultiSelectDialog<T>> {
  final _selectedValues = Set<T>();

  void initState() {
    super.initState();
    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll(widget.initialSelectedValues);
    }
  }

  void _onItemCheckedChange(T itemValue, bool checked) {
    setState(() {
      if (checked) {
        _selectedValues.add(itemValue);
      } else {
        _selectedValues.remove(itemValue);
      }
    });
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  void _onSubmitTap() {
    if (_selectedValues != null) {
      Navigator.pop(context, _selectedValues);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Employees'),
      contentPadding: EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
          child: ListBody(
            children: widget.items.map(_buildItem).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: _onCancelTap,
        ),
        FlatButton(
          child: Text('OK'),
          onPressed: _onSubmitTap,
        )
      ],
    );
  }

  Widget _buildItem(MultiSelectDialogItem<T> item) {
    final checked = _selectedValues.contains(item.value);
    return CheckboxListTile(
      value: checked,
      title: Text(item.label),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onItemCheckedChange(item.value, checked),
    );
  }
}

//END StackOverflow Code

class TaskAddForm extends StatefulWidget {
  final GroupDataModel groupData;
  final String initialTitle;
  final String initialDescription;
  final List<DocumentReference> initialUsers;
  final DateTime initialDeadline;
  @override
  TaskAddForm(this.groupData, {this.initialTitle, this.initialDescription, this.initialUsers, this.initialDeadline});
  _TaskAddFormState createState() => _TaskAddFormState(currentTitle: initialTitle, currentDescription: initialDescription, currentUsers: initialUsers, currentDeadline: initialDeadline);
}

class _TaskAddFormState extends State<TaskAddForm> {
  final _formkey = GlobalKey<FormState>();
  //final List<String> sugars = ['0','1','2','3','4'];

  // form values
  String currentTitle;
  String currentDescription;  
  List<DocumentReference> currentUsers;
  DateTime currentDeadline;
  _TaskAddFormState({this.currentTitle, this.currentDescription, this.currentUsers, this.currentDeadline});
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
          initialSelectedValues: (currentUsers != null
              ? currentUsers.toSet()
              : null), // initially select users from state
        );
      },
    );
    if (selectedValues != null && selectedValues.length != 0) {
      setState(() {
        currentUsers = selectedValues.toList();
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

  //MULTI SELECT FUNCTION

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
                initialValue: currentTitle ?? "",
                validator: (val) => val.isEmpty ? "Please enter title" : null,
                onChanged: (val) => setState(() => currentTitle = val),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                decoration:
                  textInputDecoration.copyWith(hintText: "Description"),
                initialValue: currentDescription?? "",
                validator: (val) =>
                    val.isEmpty ? "Please enter description" : null,
                onChanged: (val) => setState(() => currentDescription = val),
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
                onChanged: (val) => setState(() => currentUsers = val.split(" ")),
              ),
*/
              // (Ava) (Parul) add a date picker below (ignore all the commented code, its old stuff from the tutorials)
              Text(currentDeadline == null
                  ? 'No date has been picked yet'
                  : currentDeadline.toString()),
              RaisedButton(
                child: Text('Pick a date'),
                onPressed: () {
                  showDatePicker(
                          context: context,
                          initialDate: currentDeadline?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030))
                      .then((date) {
                    setState(() {
                      currentDeadline = date;
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
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (_formkey.currentState.validate()) {
                    await DatabaseService(userRef: user.ref).createTask(
                      currentTitle,
                      currentDescription,
                      widget.groupData.ref,
                      user.ref,
                      currentUsers,
                      currentDeadline,
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
