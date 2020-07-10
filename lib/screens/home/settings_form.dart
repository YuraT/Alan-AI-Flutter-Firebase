import 'package:flutter/material.dart';
import 'package:project1/models/user.dart';
import 'package:project1/services/database.dart';
import 'package:project1/shared/constants.dart';
import 'package:project1/shared/loading.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formkey = GlobalKey<FormState>();

  // form values
  String _currentFirstName;
  String _currentLastName;
  String _currentUsername;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<CurrentUserData>(
        stream: DatabaseService(userUid: user.uid).currentUserData,
        builder: (context, snapshot) {
          // print(snapshot.hasData);
          if (snapshot.hasData) {
            CurrentUserData currentUser = snapshot.data;
            // print(currentUser.tasks[0].time);
            return Form(
              key: _formkey,
              child: Column(
                children: <Widget>[
                  Text(
                    "Update your settings",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 15.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "First Name",
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[400])),
                    ),
                    initialValue: currentUser.firstName,
                    validator: (val) =>
                    val.isEmpty ? "Please enter first name" : null,
                    onChanged: (val) => setState(() => _currentFirstName = val),
                  ),
                  SizedBox(
                    height: 13.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Last Name",
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[400])),
                    ),
                    initialValue: currentUser.lastName,
                    validator: (val) =>
                    val.isEmpty ? "Please enter last name" : null,
                    onChanged: (val) => setState(() => _currentLastName = val),
                  ),
                  SizedBox(
                    height: 13.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Username",
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[400])),
                    ),
                    initialValue: currentUser.username,
                    validator: (val) =>
                    val.isEmpty ? "Please enter username name" : null,
                    onChanged: (val) => setState(() => _currentUsername = val),
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
                  SizedBox(height: 14.0),
                  MaterialButton(
                    color: Colors.blue[600],
                    minWidth: double.infinity,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: Text(
                      "Update",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formkey.currentState.validate()) {
                        await DatabaseService(userUid: currentUser.uid)
                            .updateUserData(
                          _currentFirstName ?? currentUser.firstName,
                          _currentLastName ?? currentUser.lastName,
                          _currentUsername ?? currentUser.username,
                        );
                        Navigator.pop(context);
                      }
                    },
                  )
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
